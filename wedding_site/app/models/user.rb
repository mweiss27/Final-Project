class User < ApplicationRecord
	has_many :guests, dependent: :destroy
	has_one :rsvp, dependent: :destroy
	belongs_to :person, optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

         attr_accessor :login, :first_name, :last_name

	validates :username,
		:presence => true,
		:uniqueness => {
			:case_sensitive => false
		}

	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			where(conditions.to_h).where(["lower(username) = :value", { :value => login.downcase }]).first
		elsif conditions.has_key?(:username)
			where(conditions.to_h).first
		end
	end

end
