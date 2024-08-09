class Room < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true
  mount_uploader :image, FacilityImageUploader
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy

  def check_in_date_cannot_be_in_the_past
    if check_in.present? && check_in < Date.today
      errors.add(:check_in, "は本日以降の日付にしてください。")
    end
  end

  def check_out_after_check_in
    return if check_out.blank? || check_in.blank?

    if check_out < check_in
      errors.add(:check_out, "はチェックイン日以降の日付にしてください。")
    end
  end


end 


