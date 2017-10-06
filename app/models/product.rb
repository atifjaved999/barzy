class Product < ApplicationRecord
  belongs_to :product_category, optional: true
  validates :name, :price, presence: true
end
