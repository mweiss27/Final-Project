class SeatingController < ApplicationController
  before_action :authenticate_user!
  before_action :check_rsvp
  helper_method :person_current_user?
  
  def check_rsvp
    r = Rsvp.find_by_user_id(current_user.id)
    if r == nil then
      redirect_to "/rsvp"
     else
      if r.response != 1 then
        redirect_to "/rsvp"
      end
    end
  end

  # Date: 07/26/2016
  # Author: Ziman Ling
  # Takes an id of a person as paramter, returns if that person is related to the current user
  def person_current_user? pid
    is_person_guest = (current_user.guests.find_by person_id: pid) ? true : false
    current_user.person.id == pid or is_person_guest
  end
  
  # Date: 07/26/2016
  # Author: Ziman Ling
  # Takes an id of a person as paramter, cancels his/her seating reservation
  def self.desotry_reservation_by_person_id person_id
    person = Person.find(person_id)
    if person.table_id and person.seat_id then
      table = Table.find(person.table_id)
      seat = "guest#{person.seat_id}_id"
      table.update(seat.to_sym => NIL)
      table.update(free: table.free + 1)
      person.update(table_id: NIL)
      person.update(seat_id: NIL)
      true
    else
      false
    end
  end
  
  # Date: 07/23/2016
  # Author: Ziman Ling
  # The rails controller method to show the seating page
  def show
    @tables = Table.all
    #@users = User.all
    #@people = Person.all
    @valid_guests = []
    
    # If person.table_id and person.seat_id are NIL then this person is available
    @valid_guests.push(current_user.person) if !current_user.person.table_id and !current_user.person.seat_id
    current_user.guests.each do |guest|
      if !guest.person.table_id and !guest.person.seat_id
        @valid_guests.push(guest.person)
      end
    end
  end

  # Date: 07/26/2016
  # Author: Ziman Ling
  # The rails controller method that handles the calcel button
  def remove
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    seat_id = params[:seat_id].to_i 
    
    # Generating the function call to access wanted table column
    seat = "guest#{seat_id}_id"
    table = @tables.find(table_id)
    person = @people.find(table.send(seat))
    
    # Check if the operation is leagal
    if person_current_user? person.id and table.id == person.table_id and table.send(seat) == person.id
      SeatingController.desotry_reservation_by_person_id person.id
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end
  
  # Date: 07/26/2016
  # Author: Ziman Ling
  # The controller method to registering a seat reservation
  def update
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    person_id = params[:guest].to_i
    
    # Filtering seat_id from the payload
    seat_id = params[:seat_id].match(/\d/).to_s.to_i
    
    # Generating the function call to access wanted table column
    seat = "guest#{seat_id}_id"
    person = @people.find(person_id)
    table = @tables.find(table_id)
    
    #Check if this action is legit
    if person_current_user? person_id and !table.send(seat) and !person.table_id
      person.update(table_id: table_id)
      person.update(seat_id: seat_id)
      table.update(seat.to_sym => person_id)
      table.update(free: table.free - 1)
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end
end