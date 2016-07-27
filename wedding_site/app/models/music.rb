class Music < ApplicationRecord
	validates :band, uniqueness: {scope: :track}
end
