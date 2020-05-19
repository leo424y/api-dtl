class Fblink < ApplicationRecord
  validates_uniqueness_of :url
end