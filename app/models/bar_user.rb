class BarUser < ApplicationRecord
  belongs_to :user
  belongs_to :bar
end
