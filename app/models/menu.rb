class Menu < ApplicationRecord
  belongs_to :bar
  has_many :product_categories, dependent: :destroy
  has_one :attachment, as: :parent, dependent: :destroy, autosave: true


  accepts_nested_attributes_for :product_categories, allow_destroy: true

  def attachment=(attrs)
    if attrs['extra']['file'].present? then build_attachment(attrs['extra']) end
  end

  def extra
    attachment if attachment.present?
  end
  
  def thumb
    attachment.file.send(:thumb).url if attachment.present?
  end

  def medium
    attachment.file.send(:medium).url if attachment.present?
  end

end
