class Room < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true
  mount_uploader :image, FacilityImageUploader
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy
end
