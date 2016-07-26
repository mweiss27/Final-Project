require "json"

class RsvpController < ApplicationController
	before_action :authenticate_user!

	def index
		puts "index. #{current_user.id}"
		@alreadyDone = false
		@attending = nil
		rsvp = Rsvp.find_by_user_id(current_user.id)
		if rsvp != nil then
			@alreadyDone = true
			@guests = "{ \"guests\": " + Guest.where(:user_id => current_user.id).to_a.to_json + "}"
			puts "Guests: #{@guests}"
			@response = Rsvp.where(:user_id => current_user.id)
			if @response != nil then
				@response = @response.first.response
				@attending = @response == 1
			end
		end

	end

	def submit


		conf = params[:rsvpConf].strip
		attending = conf != nil && conf.to_i == 1
		if conf != nil then
			rsvp = Rsvp.find_by_user_id(current_user.id)
			if rsvp == nil then
				rsvp = Rsvp.new(:user_id => current_user.id)
			end
			rsvp.response = attending ? 1 : 0
			if !rsvp.save then
				@error = "We were unable to handle your RSVP."
			end
			
			name = "#{current_user.first_name} #{current_user.last_name}"
			if attending then
				guests = params[:guests]
				if guests != nil then
					if guests.size > 0 then

						puts "Destroying #{Guest.where(:user_id => current_user.id).length} guests"
						Guest.where(:user_id => current_user.id).destroy_all

						puts "Attempting to save #{guests.size} guests."
						guests.size.times do |i|
							idx = (i+1).to_s
							f = guests[idx]["first"].strip
							l = guests[idx]["last"].strip
							guest = Guest.new(:first_name => f, :last_name => l, :user_id => current_user.id, :rsvp_id => rsvp.id)
							if guest.save then
								puts "We saved Guest: #{f} #{l} successfully."
							else
								puts "We failed to save Guest: #{f} #{l}"
								@error = "We were unable to register #{f} #{l} as a guest."
							end
						end
					end
				end
			else
				puts "Destroying #{Guest.where(:user_id => current_user.id).length} guests"
				Guest.where(:user_id => current_user.id).destroy_all
			end
			redirect_to controller: "rsvp", action: "index"
			return
		end
	end

end
