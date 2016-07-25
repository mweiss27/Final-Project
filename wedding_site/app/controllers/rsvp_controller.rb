class RsvpController < ApplicationController
	skip_before_action :verify_authenticity_token

	def submit
		puts "RSVP SUBMIT!"
		conf = params[:rsvpConf].strip
		attending = conf != nil && conf.to_i == 1
		name = "#{current_user.first_name} #{current_user.last_name}"
		if attending then
			
		else 
		end
	end

end
