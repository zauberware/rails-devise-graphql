module Regex
  class Email
    VALIDATE = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    VALIDATE_OR_EMPTY = /(^$|#{VALIDATE})/i
  end
end