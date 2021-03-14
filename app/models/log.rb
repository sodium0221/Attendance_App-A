class Log < ApplicationRecord
  belongs_to :attendance
  
  validates :worked_on, presence: true
end
