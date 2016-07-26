class SeatingController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @tables = Table.all
    @users = User.all
    @guests = Guest.all
    @my_guests = current_user.guests
    puts current_user.person.first_name
  end

  def remove
    @tables = Table.all
    @guests = Guest.all
    table_id = params[:id].to_i
    seat = "guest#{params[:seat_id]}_id"
    table = @tables.find(table_id)
    guest = @guests.find(table.send(seat))
    table.update(seat.to_sym => NIL)
    table.update(free: table.free + 1)
    guest.update(table_id: NIL)
    redirect_to "/seating"
    
  end

  def update
    @tables = Table.all
    @guests = Guest.all
    table_id = params[:id].to_i
    guest_id = params[:guest].to_i
    seat = "guest#{params[:seat_id].match(/\d/)}_id"
    puts params
    guest = @guests.find(guest_id)
    table = @tables.find(table_id)
    #Check if this action is legit
    if guest.user_id == current_user.id and !table.send(seat) and !guest.table_id
      guest.update(table_id: table_id)
      table.update(seat.to_sym => guest_id)
      table.update(free: table.free - 1)
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end
end