# frozen_string_literal: true

# Base class for all application records
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
