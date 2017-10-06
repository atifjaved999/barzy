class NeedHelp < ApplicationRecord
  validates :email, :description, presence: true
end
