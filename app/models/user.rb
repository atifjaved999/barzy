class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :admins, -> { where(role: "Admin") }

  scope :only_users, -> {where(role: "User")}

  scope :super_and_admins, -> { where(role: ["Super Admin", "Admin"]) }

  has_many :bar_users, dependent: :destroy
  has_many :bars, through: :bar_users

  validates :first_name, presence: true


  def is?( requested_role )
   self.role == requested_role.to_s
  end

  def self.is_valid_user(email,password)
    user = User.find_by_email(email)
    user and user.valid_password?(password) ? user : nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
end
