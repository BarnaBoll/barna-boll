class Location < ApplicationRecord
  belongs_to :city
  has_many :matches, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: 150 }
  validates :address, length: { maximum: 255 }, allow_blank: true

  def name_with_city
    "#{city.name} – #{name}"
  end
end
