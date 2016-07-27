require "json"

class RsvpController < ApplicationController
	before_action :authenticate_user!
	helper_method :gather_guests

	def initialize
		super

		@@cache ||= []
	end

	def index
		puts "index. #{current_user.id}"
		puts "INDEX. HASH: #{self.object_id}"

		@@cache[current_user.id] = [] #Wipe if stuff was there before

		@rsvp = Rsvp.find_by_user_id(current_user.id)
		@alreadyDone = @rsvp != nil

		if @alreadyDone then
			response = @rsvp.response
			@attending = response == 1

			current_user.guests.each_with_index do |g, i|
				puts "Setting cache idx #{i+1} to #{g}"
				@@cache[current_user.id][i+1] = g
			end
			puts "Cache: #{@@cache}"
			puts "Cache[1]: #{@@cache[current_user.id][1]}"
		end

		@rsvp ||= @rsvp = Rsvp.new(:user_id => current_user.id)

		@attending = nil
		
		# puts "Creating @guestsA"
		# @guestsA = []
		
		# if @rsvp != nil then
		# 	@alreadyDone = true

		# 	g = Guest.where(:user_id => current_user.id)


		# 	g.each do |g| @guestsA << g end

		# 	@guests = "{ \"guests\": " + g.to_a.to_json + "}"
		# 	puts "Guests: #{@guests}"
		# 	@response = Rsvp.where(:user_id => current_user.id)
		# 	if @response != nil then
		# 		@response = @response.first.response
		# 		@attending = @response == 1
		# 	end
		# end
		# puts "@guestsA: #{@guestsA}"
		# if @rsvp == nil then
		# 	@rsvp = Rsvp.new(:user_id => current_user.id)
		# end
		@choices = Accommodation.all
	end

	def add_guest
		@@cache[current_user.id] ||= []
		cu = current_user
		puts "cu: #{cu}"
		rsvp = Rsvp.find_by_user_id(cu.id)
		puts "rsvp: #{rsvp}"
		ng = Guest.new(:user_id => cu.id, :rsvp_id => rsvp.id)
		puts "ng: #{ng}"
		puts "@@cache: #{@@cache[current_user.id]}"
		@@cache[current_user.id][@@cache[current_user.id].length] = ng #Temporary guest
		puts "add_guest done"
		update_guests
	end

	def remove_guest
		id = params[:id].to_i
		@@cache[current_user.id][id] = nil
		(id..4).step(1) do |i|
			@@cache[current_user.id][i] = @@cache[current_user.id][i+1]
		end
		puts "Guest removed. @@cache[user]: #{@@cache[current_user.id]}"
		clean_guests
		update_guests
	end

	def list_guests
		guests = current_user.guests
		respond_to do |format|
	        format.html { render :partial => "/rsvp/guestChoices", :locals => { :guests => guests } }
	        format.js
		end
	end

	def update_guests
		respond_to do |format|
	        format.html { render :partial => "/rsvp/guests", :locals => { :guests => gather_guests } }
	        format.js
		end
	end

	def gather_guests
		puts "Gathering guests"
		puts "Cache: #{@@cache[current_user.id]}"
		@@cache[current_user.id] ||= []
		guests = []
		(1..@@cache[current_user.id].length).step(1) do |i|
			if @@cache[current_user.id][i] != nil then
				puts "\tAdding #{@@cache[current_user.id][i]}"
				guests << @@cache[current_user.id][i]
			else
				puts "Guest is nil at index #{i}"
			end
		end
		guests
	end

	def clean_guests
		ours = @@cache[current_user.id]
		ours.pop until ours.empty? or ours.last
	end

	def submit
		puts "SUBMIT. HASH: #{self.object_id}"


		guests = gather_guests
		guests.each do |g|
			puts "Guest: #{g}"
			puts "Guest.save? #{g.save}"
		end

		# conf = params[:rsvpConf].strip
		# attending = conf != nil && conf.to_i == 1
		# if conf != nil then
			
		# 	@rsvp.response = attending ? 1 : 0
		# 	if !@rsvp.save then
		# 		@error = "We were unable to handle your RSVP."
		# 	end
		# 	name = "#{current_user.first_name} #{current_user.last_name}"
		# 	if attending then
		# 		guests = params[:guests]
		# 		if guests != nil then
		# 			if guests.size > 0 then

		# 				puts "Destroying #{Guest.where(:user_id => current_user.id).length} guests"
		# 				Guest.where(:user_id => current_user.id).each do |g|
  #             				SeatingController.desotry_reservation_by_person_id g.person.id
		# 					Person.where(:id => g.person_id).destroy_all
		# 					g.destroy
		# 				end

		# 				puts "Attempting to save #{guests.size} guests."
		# 				guests.size.times do |i|
		# 					idx = (i+1).to_s
		# 					f = guests[idx]["first"].strip
		# 					l = guests[idx]["last"].strip
		# 					person = Person.new(:first_name => f, :last_name => l)
		# 					person.save
		# 					guest = Guest.new(:user_id => current_user.id, :rsvp_id => @rsvp.id, :person_id => person.id, :first_name => f, :last_name => l)
		# 					if guest.save then
		# 						puts "We saved Guest: #{f} #{l} successfully."
		# 					else
		# 						puts "We failed to save Guest: #{f} #{l}"
		# 						@error = "We were unable to register #{f} #{l} as a guest."
		# 					end
		# 				end
		# 			end
		# 		end
		# 	else
		# 		puts "Destroying #{Guest.where(:user_id => current_user.id).length} guests"
		#       SeatingController.desotry_reservation_by_person_id current_user.id
		# 		guests_to_destory = Guest.where(:user_id => current_user.person.id)
		#       guests_to_destory.each {|g| SeatingController.desotry_reservation_by_person_id g.person.id}
		#       guests_to_destory.destroy_all
		# 	end
		# 	redirect_to controller: "rsvp", action: "index"
		# 	return
		# end
	end

end
