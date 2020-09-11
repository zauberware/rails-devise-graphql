user = User.create(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  first_name: ENV['ADMIN_FIRST_NAME'],
  last_name: ENV['ADMIN_LAST_NAME'],
  role: 'superadmin'
)

if user
  Rails.logger.info "Login with #{ENV['ADMIN_EMAIL']} and #{ENV['ADMIN_PASSWORD']}"
end