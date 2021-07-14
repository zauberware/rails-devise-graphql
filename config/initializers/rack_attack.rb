# frozen_string_literal: true

Rack::Attack.enabled = false if ENV['RACK_ATTACK_ENABLED'] == 'false'
# otherwise default ON

# rubocop:disable Metrics/ClassLength
module Rack
  # Define roles for blocking users
  class Attack
    def self.user_session?(req)
      # stored in cookies
      if req.env['rack.request.cookie_hash'] && req.env['rack.request.cookie_hash']['user']
        user = JSON.parse(req.env['rack.request.cookie_hash']['user'])
        return true if user && user['email'].present?
      end

      # devise is storing user id in rack.session after a valid authentication
      req.env['rack.session'] &&
        req.env['rack.session']['warden.user.user.key'] &&
        req.env['rack.session']['warden.user.user.key'][0][0]
    end

    # Always allow requests from localhost
    # (blocklist & throttles are skipped)
    Rack::Attack.safelist('allow from localhost') do |req|
      # Requests are allowed if the return value is truthy
      req.ip == '127.0.0.1' || req.ip == '::1'
    end

    # Always allow requests from localhost
    # (blocklist & throttles are skipped)
    whitelist = ENV['RACK_WHITELIST'] ? ENV['RACK_WHITELIST'].split(',') : []
    Rack::Attack.safelist('allow from ENV ATTACK_WHITELIST') do |req|
      # Requests are allowed if the return value is truthy
      whitelist.include?(req.ip)
    end

    # If any single client IP is making tons of requests, then they're
    # probably malicious or a poorly-configured scraper. Either way, they
    # don't deserve to hog all of the app server's CPU. Cut them off!
    #
    # Note: If you're serving assets through rack, those requests may be
    # counted by rack-attack and this throttle may be activated too
    # quickly. If so, enable the condition to exclude them from tracking.

    # Throttle all requests by IP
    request_limit = (ENV['ATTACK_REQUEST_LIMIT'] || 300).to_i
    request_period = (ENV['ATTACK_REQUEST_PERIOD_IN_MINUTES'] || 5).to_i
    ban_time = (ENV['ATTACK_REQUEST_BAN_TIME_IN_MINUTES'] || 30).to_i
    (1..3).each do |level|
      # level 1 -> 300 requests in 5 minutes (60rpm), ban for 30 minutes
      # level 2 -> 600 requests in 25 minutes (24rpm), ban for 60 minutes
      # level 3 -> 900 requests in 125 minutes (7.2rpm), ban for 90 minutes
      throttle(
        "request/ip/#{level}",
        limit: request_limit * level,
        period: (request_period**level).minutes,
        bantime: (ban_time * level).minutes
      ) do |req|
        req.ip if !req.path.start_with?('/assets') && !Rack::Attack.user_session?(req)
      end
    end

    # Throttle authenticated requests by IP
    request_limit = (ENV['ATTACK_AUTHENTICATED_REQUEST_LIMIT'] || 500).to_i
    request_period = (ENV['ATTACK_AUTHENTICATED_REQUEST_PERIOD_IN_MINUTES'] || 5).to_i
    ban_time = (ENV['ATTACK_AUTHENTICATED_REQUEST_BAN_TIME_IN_MINUTES'] || 10).to_i
    (1..3).each do |level|
      # level 1 -> 500 requests in 5 minutes (100rpm), ban for 10 minute
      # level 2 -> 1000 requests in 25 minutes (40rpm), ban for 20 minutes
      # level 3 -> 1500 requests in 125 minutes (12rpm), ban for 30 minutes
      throttle(
        "request/authenticated/ip/#{level}",
        limit: request_limit * level,
        period: (request_period**level).minutes,
        bantime: (ban_time * level).minutes
      ) do |req|
        req.ip if !req.path.start_with?('/assets') && Rack::Attack.user_session?(req)
      end
    end

    ### Prevent Brute-Force Attacks ###

    # The most common brute-force login attack is a brute-force password
    # attack where an attacker simply tries a large number of emails and
    # passwords to see if any credentials match.
    #
    # Another common method of attack is to use a swarm of computers with
    # different IPs to try brute-forcing a password for a specific account.

    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
    # LOGIN / SIGN UP

    auth_limit = (ENV['ATTACK_AUTH_LIMIT'] || 30).to_i
    auth_period = (ENV['ATTACK_AUTH_PERIOD_IN_MINUTES'] || 10).to_i
    auth_ban_time = (ENV['ATTACK_AUTH_BAN_TIME_IN_MINUTES'] || 30).to_i

    (1..3).each do |level|
      # level 1 -> 30 auth requests in 10 minutes, ban for 30 minutes
      # level 2 -> 60 auth requests in 100 minutes, ban for 60 minutes
      # level 3 -> 90 auth requests per 1000 minutes (16,5 hours), ban for 120 minutes

      # Devise sign_in
      throttle(
        "request/devise/ip/#{level}",
        limit: auth_limit * level,
        period: (auth_period**level).minutes,
        bantime: (auth_ban_time * level).minutes
      ) do |req|
        req.ip if req.path == '/users/sign_in' && (req.post? || req.put?)
      end

      # Devise password reset
      throttle(
        "request/devise/password/ip/#{level}",
        limit: auth_limit * level,
        period: (auth_period**level).minutes,
        bantime: (auth_ban_time * level).minutes
      ) do |req|
        req.ip if req.path == '/users/password' && (req.post? || req.put?)
      end

      # GraphQL login & signup via api
      throttle(
        "request/graphql/auth/ip/#{level}",
        limit: auth_limit * level,
        period: (auth_period**level).minutes,
        bantime: (auth_ban_time * level).minutes
      ) do |req|
        if req.path == '/graphql' && req.post? && req.body
          params = JSON.parse(req.body.read)
          req.body.rewind # needed a rewind after parsing it to JSON
          if params['query'].include?('signIn') ||
             params['query'].include?('signUp')
            req.ip
          end
        end
      end

      # GraphQL password reset
      throttle(
        "request/graphql/password_reset/ip/#{level}",
        limit: auth_limit * level,
        period: (auth_period**level).minutes,
        bantime: (auth_ban_time * level).minutes
      ) do |req|
        if req.path == '/graphql' && req.post? && req.body
          params = JSON.parse(req.body.read)
          req.body.rewind # needed a rewind after parsing it to JSON
          req.ip if params['query'].include?('resetPassword')
        end
      end
    end

    # Actions
    # Limits actions like locking a user or create a message
    public_action_limit = (ENV['ATTACK_PUBLIC_ACTION_LIMIT'] || 30).to_i
    public_action_period = (ENV['ATTACK_PUBLIC_ACTION_PERIOD_IN_MINUTES'] || 60).to_i
    public_action_ban_time = (ENV['ATTACK_PUBLIC_ACTION_BAN_TIME_IN_MINUTES'] || 30).to_i

    throttle(
      'request/public/action/ip',
      limit: public_action_limit,
      period: public_action_period.minutes,
      bantime: public_action_ban_time.minutes
    ) do |req|
      if req.path == '/graphql' && req.post? && req.body
        params = JSON.parse(req.body.read)
        req.body.rewind # needed a rewind after parsing it to JSON
        if params['query'].include?('unlockAccount') ||
           params['query'].include?('lockAccount') ||
           params['query'].include?('createConversation') ||
           params['query'].include?('createMessage')
          req.ip
        end
      end
    end

    ### Custom Throttle Response ###
    # Add a helpful response about the rate limit for clients
    # For responses that did not exceed a throttle limit, Rack::Attack annotates the env with match data:
    # request.env['rack.attack.throttle_data'][name]
    # => { discriminator: d, count: n, period: p, limit: l, epoch_time: t }
    self.throttled_response = lambda do |_env|
      # match_data = env['rack.attack.match_data']
      # now = match_data[:epoch_time]

      headers = {}

      [429, headers, [{ 'errors': [{ 'message': 'Too many requests' }] }.to_json]]
    end
  end
end

# Error reporting
ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, start, _finish, _request_id, payload|
  # request object available in payload[:request]
  if %i[throttle blacklist].include? payload[:request].env['rack.attack.match_type']
    error = [
      payload[:request].env['rack.attack.match_type'],
      name,
      start,
      payload[:request].ip,
      payload[:request].request_method,
      payload[:request].fullpath
    ].join(' ')
    Rails.logger.warn error
    # Rollbar.warning(error, payload[:request].env)
  end
end
# rubocop:enable Metrics/ClassLength
