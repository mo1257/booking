class Reservation < ApplicationRecord
  mount_uploader :image, FacilityImageUploader
end
