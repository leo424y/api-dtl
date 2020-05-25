# frozen_string_literal: true

class Fblink < ApplicationRecord
  validates_uniqueness_of :url
end
