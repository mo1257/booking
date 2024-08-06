class Reservation < ApplicationRecord
  mount_uploader :image, FacilityImageUploader
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :people, numericality: true, numericality: { only_integer: true, greater_than: 0 }

end
