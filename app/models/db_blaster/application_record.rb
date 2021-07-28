# frozen_string_literal: true

module DbBlaster
  # Base class for models
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
