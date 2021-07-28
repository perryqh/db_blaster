# frozen_string_literal: true

module DbBlaster
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
