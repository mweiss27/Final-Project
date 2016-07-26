class RsvpController < ApplicationController
	skip_before_action :verify_authenticity_token

	def submit

		rsvp = Rsvp.new(:user_id => current_user.id)
		rsvp.save

		conf = params[:rsvpConf].strip

		attending = conf != nil && conf.to_i == 1
		name = "#{current_user.first_name} #{current_user.last_name}"
		if attending then
			guests = params[:guests]
			if guests != nil then
				puts guests
				if guests.size > 0 then
					guests.size.times do |i|
						idx = (i+1).to_s
						f = guests[idx]["first"]
						l = guests[idx]["last"]
						guest = Guest.new(:first_name => f, :last_name => l, :user_id => current_user.id)
						if guest.save then
							puts "We saved Guest: #{f} #{l} successfully."
						else
							puts "We failed to save Guest: #{f} #{l}"
						end
					end
				else
					puts "No guests :("
				end
			else
				puts "No guests were added."
			end
		else 
		end
	end

end
