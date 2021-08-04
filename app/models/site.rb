class Site < ApplicationRecord
  
  validates :site_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}, length: { maximum: 5 }
  validates :site_name, presence: true, length: { maximum: 10 }
  validates :site_status, presence: true
end
