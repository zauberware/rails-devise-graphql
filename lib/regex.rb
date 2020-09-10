# frozen_string_literal: true

module Regex
  class Email
    VALIDATE = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
    VALIDATE_OR_EMPTY = /(^$|#{VALIDATE})/i.freeze
  end
end
