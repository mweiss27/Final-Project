class Guest < ApplicationRecord
	belongs_to :user
	belongs_to :person
end
