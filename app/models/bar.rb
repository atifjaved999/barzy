class Bar < ApplicationRecord
  DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
  has_many :bar_users, dependent: :destroy
  has_many :users, through: :bar_users
  has_many :bar_categories, dependent: :destroy
  has_many :categories, through: :bar_categories
  has_many  :attachments, as: :parent, dependent: :destroy, autosave: true
  has_one :menu, dependent: :destroy
  has_many :timings, dependent: :destroy
  has_many :business_infos, dependent: :destroy

  accepts_nested_attributes_for :menu, allow_destroy: true
  accepts_nested_attributes_for :timings, allow_destroy: true
  accepts_nested_attributes_for :business_infos, allow_destroy: true

  # validates :name, presence: true, uniqueness: true
  # validates :name, presence: true, uniqueness: {scope: [:zip_code]}
  validates_length_of :description, :maximum => 50, :allow_blank => true

  after_create  :create_menu

  geocoded_by :address, :latitude  => :lat, :longitude => :lng
  after_validation :geocode , if: ->(obj){ obj.address.present? and obj.address_changed?}
  # after_validation :check_geocode
  default_scope { where(status: nil) }

  def check_geocode
    if self.address.present? && self.lat.blank? || self.lng.blank?
      goto_geocode
    elsif self.address.present? and self.address_changed?
      goto_geocode
    end
  end

  def goto_geocode
    3.times do
       break if geocode
    end
  end

  def attachments=(attrs)
    if attrs['bar_photos'] and attrs['bar_photos']['file'].present? 
      then attrs['bar_photos']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['bar_photos']['parent_id'], 
      parent_type: attrs['bar_photos']['parent_type'], role: attrs['bar_photos']['role']) } 
    end
  end

  def bar_photos
    attachments.for_multi('bar_photos')
  end

  def create_menu
    am = self.build_menu
    am.save
    puts 'Menu created'
  end

  def get_duration opening, closing
    # opening = Time.parse(opening_time)
    # closing = Time.parse(closing)
    duration = 0.0
    if opening <= closing
      duration = (closing.hour - opening.hour) + (closing.min.to_f - opening.min)/60.0
    elsif opening > closing
      duration = ((closing.hour + 24) - opening.hour) + (closing.min.to_f - opening.min)/60.0
    end
    duration
  end

  def is_open_now
    current = Time.now.in_time_zone("America/Los_Angeles")
    # current = current.change(:month => 1, :day => 1, :year => 2000)
    if self.current_day.present?
      opening = self.current_day.opening_time
      closing = self.current_day.closing_time
      bar_duration = self.get_duration(opening, closing)
      current_duration = self.get_duration(opening, current)
      current_duration < bar_duration
    else
      false
    end

  end

  def current_day
    current_day = self.timings.find_by(day: [Time.now.strftime("%A"), Time.now.strftime("%a")])
  end

  def today_opening_time
    self.current_day.opening_time if self.current_day.present?
  end

  def today_closing_time
    self.current_day.closing_time if self.current_day.present?
  end

end
