class Review < ApplicationRecord
  belongs_to :restaurant
  validates :rating, inclusion: { in: 1..5 }
  validates :author, presence: true
end