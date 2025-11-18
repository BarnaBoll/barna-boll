class PlayerStat < ApplicationRecord
  belongs_to :user
  belongs_to :city
  belongs_to :location
end
