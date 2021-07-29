# frozen_string_literal: true

module DbBlaster
  # Represents tables that should be synced
  class SourceTable < ApplicationRecord
    include Sync

    validates :name, uniqueness: { case_sensitive: false }, presence: true
  end
end
