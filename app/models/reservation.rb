class Reservation < ApplicationRecord
  mount_uploader :image, FacilityImageUploader
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :people, numericality: { only_integer: true, greater_than: 0 }
  
 

  validate :check_in_date_cannot_be_in_the_past
  validate :check_out_after_check_in

  private

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
