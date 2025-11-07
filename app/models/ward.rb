class Ward < ApplicationRecord
  has_many :restaurants, dependent: :nullify
  validates :name, presence: true
end