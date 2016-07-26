class SeatingController < ApplicationController
  before_action :authenticate_user!
  helper_method :person_current_user?
  
  def person_current_user? pid
    is_person_guest = (current_user.guests.find_by person_id: pid) ? true : false
    current_user.person.id == pid or is_person_guest
  end
  
  def show
    @tables = Table.all
    @users = User.all
    @people = Person.all
    @my_people = []
    @my_people.push(current_user.person)
    current_user.guests.each{|guest| @my_people.push(guest.person)}
    puts @mypeople
  end

  def remove
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    seat = "guest#{params[:seat_id]}_id"
    table = @tables.find(table_id)
    person = @people.find(table.send(seat))
    if person_current_user? person.id and table.id == person.table_id and table.send(seat) == person.id
      table.update(seat.to_sym => NIL)
      table.update(free: table.free + 1)
      person.update(table_id: NIL)
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
    
  end

  def update
    @tables = Table.all
    @people = Person.all
    table_id = params[:id].to_i
    person_id = params[:guest].to_i
    seat = "guest#{params[:seat_id].match(/\d/)}_id"
    puts params
    person = @people.find(person_id)
    table = @tables.find(table_id)
    #Check if this action is legit
    if person_current_user? person_id and !table.send(seat) and !person.table_id
      person.update(table_id: table_id)
      table.update(seat.to_sym => person_id)
      table.update(free: table.free - 1)
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end
end