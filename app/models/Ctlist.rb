# frozen_string_literal: true

class Ctlist < ApplicationRecord
  validates_uniqueness_of :listid
  validates_uniqueness_of :creator
end
