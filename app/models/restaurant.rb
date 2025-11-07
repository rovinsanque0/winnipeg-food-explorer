class Restaurant < ApplicationRecord
  belongs_to :ward, optional: true
  has_many :inspections, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :latitude, :longitude, numericality: true, allow_nil: true

  scope :search, ->(q) {
    return all if q.blank?
    where("LOWER(name) LIKE ? OR LOWER(address) LIKE ?", "%#{q.downcase}%", "%#{q.downcase}%")
  }
  scope :by_ward, ->(ward_id) { ward_id.present? ? where(ward_id:) : all }
  scope :by_category, ->(category_id) {
    if category_id.present?
      joins(:categorizations).where(categorizations: { category_id: })
    else
      all
    end
  }
end