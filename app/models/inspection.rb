class Inspection < ApplicationRecord
  belongs_to :restaurant
  validates :inspected_on, presence: true
end