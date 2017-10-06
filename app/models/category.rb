class Category < ApplicationRecord
  has_many :bar_categories, dependent: :destroy
  has_many :bars, through: :bar_categories
  has_one :attachment, as: :parent, dependent: :destroy, autosave: true

  validates :name, presence: true, uniqueness: true

  def attachment=(attrs)
    if attrs['photo']['file'].present? then build_attachment(attrs['photo']) end
  end

  def photo
    attachment if attachment.present?
  end
  
  def thumb
    attachment.file.send(:thumb).url if attachment.present?
  end

  def medium
    attachment.file.send(:medium).url if attachment.present?
  end

end

