# app/models/city.rb
class City < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :matches, through: :locations

  validates :name, presence: true, length: { maximum: 100 }
  validates :color, length: { maximum: 50 }, allow_blank: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  def to_param
    slug.presence || id.to_s
  end

  def self.from_param(param)
    str = param.to_s

    if str.match?(/\A\d+\z/)
      find(str)
    else
      find_by!(slug: str)
    end
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end
end
