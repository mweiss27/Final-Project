class SeatingController < ApplicationController
  before_action :authenticate_user!
  helper_method :person_current_user?
  
  def person_current_user? pid
    is_person_guest = (current_user.guests.find_by person_id: pid) ? true : false
    current_user.person.id == pid or is_person_guest
  end
  
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
  
  def show
    if Rsvp.find(current_user.rsvp_id).response != 1 then redirect_to "/rsvp" end
    @tables = Table.all
    @users = User.all
    @people = Person.all
    @my_people = []
    @my_people.push(current_user.person)
    current_user.guests.each{|guest| @my_people.push(guest.person)}
  end

  def remove
    if Rsvp.find(current_user.rsvp_id).response != 1 then redirect_to "/rsvp" end
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    seat_id = params[:seat_id].to_i 
    seat = "guest#{seat_id}_id"
    table = @tables.find(table_id)
    person = @people.find(table.send(seat))
    if person_current_user? person.id and table.id == person.table_id and table.send(seat) == person.id
      SeatingController.desotry_reservation_by_person_id person.id
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end

  def update
    if Rsvp.find(current_user.rsvp_id).response != 1 then redirect_to "/rsvp" end
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    person_id = params[:guest].to_i
    seat_id = params[:seat_id].match(/\d/).to_s.to_i
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