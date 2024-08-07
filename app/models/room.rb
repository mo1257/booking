class Room < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true
  mount_uploader :image, FacilityImageUploader
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy

  def date_before_start
    return if start_day.blank?
    errors.add(:start_day, "は今日以降のものを選択してください") if start_day < Date.today
  end

  def date_before_finish
    return if last_day.blank? || start_day.blank?
    errors.add(:last_day, "は開始日以降のものを選択してください") if last_day < start_day
  end


end 


