# Date: 07/22/2016
# Author: Matt
require "json"

class RsvpController < ApplicationController
	before_action :authenticate_user!
	helper_method :gather_guests, :gather_choices, :get_selection_for_guest, :get_person_for_guest

	def initialize
		super

		@@cache ||= []
		puts "INIT @@cache: #{@@cache}"
	end

	def index
		puts "index. #{current_user.id}"
		puts "INDEX. HASH: #{self.object_id}"
		@@cache[current_user.id] = [] #Wipe if stuff was there before

		rsvp = Rsvp.find_by_user_id(current_user.id)
		@alreadyDone = rsvp != nil

		@attending = nil
		if @alreadyDone then
			response = rsvp.response
			@attending = response == 1

			current_user.guests.each_with_index do |g, i|
				puts "Setting cache idx #{i+1} to #{g}"
				@@cache[current_user.id][i+1] ||= Hash.new
				@@cache[current_user.id][i+1]["guest"] = g
				@@cache[current_user.id][i+1]["person"] = g.person
			end
			puts "Cache: #{@@cache}"
			puts "Cache[1]: #{@@cache[current_user.id][1]}"
		end
		@cache = @@cache[current_user.id]
		
		puts ("rsvp = #{rsvp == nil ? 'nil' : rsvp}")
		
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
		puts "rsvp: #{rsvp == nil ? 'nil' : rsvp}"

		ng = Guest.new(:user_id => cu.id)

		puts "ng: #{ng}"
		puts "@@cache: #{@@cache[current_user.id]}"
		idx = [1, @@cache[current_user.id].length].max
		puts "Adding guest at idx #{idx}"
		@@cache[current_user.id][idx] ||= Hash.new
		@@cache[current_user.id][idx]["guest"] = ng #Temporary guest
		@@cache[current_user.id][idx]["person"] = Person.new(:first_name => "", :last_name => "")
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

	#Save our temporary state
	def save_guests
		puts "SAVE GUESTS"
		if params["data"] != nil then
			json_o = JSON.parse(params["data"])
			guests = json_o["guests"]
			puts "guests: #{guests}"
			puts "@@cache: #{@@cache}"
			c = @@cache[current_user.id]
			puts "c: #{c}"
			(1..c.length).step(1) do |i|
				if c[i] != nil then
					puts "c[#{i}] exists."
					puts "We were passed first_name: #{guests[i]["first_name"]} and last_name: #{guests[i]["last_name"]}"
					c[i]["person"].first_name = guests[i]["first_name"]
					c[i]["person"].last_name = guests[i]["last_name"]
				else
					puts "c[#{i}] is nil"
				end
			end
			puts "@@cache[user]: #{@@cache[current_user.id]}"
		end
	end

	def update_guests
		respond_to do |format|
	        format.html { render :partial => "/rsvp/guests", :locals => { :guests => gather_guests, :cache => @@cache[current_user.id] } }
	        format.js
		end
	end

	def update_choices
		respond_to do |format|
			format.html { render :partial => "/rsvp/guestChoices", :locals => { :guests => gather_guests, :choices => gather_choices } }
		end
	end

	def update_user_choice
		respond_to do |format|
			format.html { render :partial => "/rsvp/userChoice", :locals => { :choices => gather_choices } }
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
				guests << @@cache[current_user.id][i]["guest"]
			else
				puts "Guest is nil at index #{i}"
			end
		end
		guests
	end

	def gather_choices 
		Accommodation.all
	end

	def clean_guests
		ours = @@cache[current_user.id]
		ours.pop until ours.empty? or ours.last
	end

	def get_accommodation_id_for selection
		acc = Accommodation.find_by_name(selection)
		if acc != nil then
			return acc.id
		end
		puts "NO ACCOMMODATION FOUND FOR #{selection}"
		return -1
	end

	def get_selection_for_guest(guest)
		puts "get_selection_for_guest: #{guest}"
		idx = 0
		(1..4).step(1) do |i|
			c = @@cache[current_user.id][i]
			if c and c["guest"] == guest then idx = i end
		end
		if guest.person or idx != 0 then
			puts "idx: #{idx}"
			person=nil
			if guest.person == nil then
				puts "printing cache"
				puts "#{@@cache[current_user.id][idx]}"
				person = @@cache[current_user.id][idx]["person"]
			else
				person = guest.person
			end
			puts "person: #{person}"
			choice = AccommodationChoice.find_by_person_id(person.id)
			if choice == nil then choice = "Steak"
			else choice = choice.accommodation.name
			end
			puts "Returning #{choice}"
			return choice
		end
		puts "We didn't find anything!"
		"Steak"
	end

	def get_person_for_guest guest
		if guest.person then return guest.person end

		idx = 0
		(1..4).step(1) do |i|
			c = @@cache[current_user.id][i]
			if c and c["guest"] == guest then idx = i end
		end
		@@cache[current_user.id][idx]["person"]
	end

	def submit
		puts "SUBMIT. HASH: #{self.object_id}"
		conf = params[:rsvpConf].strip
		guest_specific = params[:guest_specific]

		attending = conf != nil && conf.to_i == 1
		rsvp = Rsvp.find_by_user_id(current_user.id)
		if rsvp == nil then
			rsvp = Rsvp.new(:user_id => current_user.id)
		end
		current_user.rsvp_id = rsvp.id
		current_user.guest_specific = guest_specific != nil and guest_specific == "on" ? 1 : 0

		current_user.save
		rsvp.response = attending ? 1 : 0
		if rsvp != nil then
			rsvp.save
		end
		if !attending then
				puts "Destroying #{Guest.where(:user_id => current_user.id).length} guests"
		      	SeatingController.desotry_reservation_by_person_id current_user.person.id
				guests_to_destory = Guest.where(:user_id => current_user.id)
		      	guests_to_destory.each {|g| SeatingController.desotry_reservation_by_person_id g.person.id}
		      	guests_to_destory.destroy_all
		else
			guests = gather_guests
			guests.each_with_index do |g, i|
				puts "Guest: #{g}"
				if g.person == nil then
					puts "This guest is new. Let's create a person!"
					fn = params["guests"]["persons"][(i+1).to_s]["first_name"]
					ln = params["guests"]["persons"][(i+1).to_s]["last_name"]
					g.person = Person.new(:first_name => fn, :last_name => ln)
					g.rsvp_id = rsvp.id
					g.person.save
				end
				if not g.save then
					puts "FAILED TO SAVE GUEST #{g}"
				end
			end

			allGuestsSaved = Guest.where(:user_id => current_user.id)
			allGuestsSaved.each do |gSaved|
				found = false
				guests.each do |g|
					if g.id == gSaved.id then found = true end
				end
				if !found then
					puts "We didn't find #{gSaved.person.first_name} attached to a User. Destroying"
					SeatingController.desotry_reservation_by_person_id gSaved.person.id
					gSaved.destroy
				end
			end

			user_selected = params["userChoice"]
			puts "user_selected: #{user_selected}"

			if current_user.guest_specific == 1 then
				user_choice = AccommodationChoice.find_by_person_id(current_user.person.id)
				user_choice ||= AccommodationChoice.new(:person_id => current_user.person.id, :accommodation_id => get_accommodation_id_for(user_selected))
				user_choice.accommodation_id = get_accommodation_id_for(user_selected)
				user_choice.save

				guest_selections = params["guestChoice"] #{"1"=>"Steak"}
				current_user.guests.each_with_index do |g, i|
					g_selected = guest_selections[(i+1).to_s]
					puts "g_selected: #{g_selected}"
					g_choice = AccommodationChoice.find_by_person_id(g.person.id)
					g_choice ||= AccommodationChoice.new(:person_id => g.person.id, :accommodation_id => get_accommodation_id_for(g_selected))
					g_choice.accommodation_id = get_accommodation_id_for(g_selected)
					g_choice.save
				end

			else
				current_user.guests.each_with_index do |g, i|
					AccommodationChoice.where(:person_id => g.person.id).destroy_all
				end
				user_choice = AccommodationChoice.find_by_person_id(current_user.person.id)
				user_choice ||= AccommodationChoice.new(:person_id => current_user.person.id, :accommodation_id => get_accommodation_id_for(user_selected))
				user_choice.accommodation_id = get_accommodation_id_for(user_selected)
				user_choice.save
			end

		end
		redirect_to controller: "rsvp", action: "index"
		return
	end

end
