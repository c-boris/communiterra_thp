class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :owned_plants, dependent: :destroy
  has_many :plants, through: :owned_plants
  has_many :plant_sittings
  has_many :kept_plants
  # has_many :private_sent_messages, class_name: 'PrivateMessage', foreign_key: 'sender_id'
  # has_many :private_received_messages, class_name: 'PrivateMessage', foreign_key: 'recipient_id'
  # has_many :posts, dependent: :destroy
  # has_many :comments, dependent: :destroy
  # has_many :likes, dependent: :destroy
  # has_many :allotment_users
  # has_many :administered_allotments, class_name: 'Allotment', foreign_key: 'admin_id', through: :allotment_users, source: :allotment, as: :admin
  # has_many :membered_allotments,  class_name: 'Allotment', foreign_key: 'member_id', through: :allotment_users, source: :allotment, as: :member

  # validates :password, presence: true, length: { minimum: 8 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,}\z/ }
  # validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  # validates :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 100 }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "email address please" }
  # validates :birthdate, presence: true
  # validates :username, presence: true, uniqueness: true

  # acts_as_messageable :table_name => "messages",                         # default 'messages'
  #                     :required   => [:topic, :body],                     # default [:topic, :body]
  #                     :class_name => "ActsAsMessageable::Message",       # default "ActsAsMessageable::Message",
  #                     :dependent  => :nullify                            # default :nullify

  # after_create :welcome_send

  # def welcome_send
  #   UserMailer.welcome_email(self).deliver_now
  # end
end