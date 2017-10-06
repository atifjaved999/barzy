class BarLink < ApplicationRecord
  validates :name, :link, :zip_code, presence: true
end
