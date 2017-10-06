class ProductCategory < ApplicationRecord
  belongs_to :menu, optional: true
  has_many :products, dependent: :destroy
  accepts_nested_attributes_for :products, allow_destroy: true

  validates :name, presence: true, uniqueness: {scope: [:menu_id]}
end
