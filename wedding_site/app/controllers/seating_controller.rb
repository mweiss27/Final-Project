class SeatingController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @tables = Table.all
    @users = User.all
    @guests = Guest.all
    puts @guests.find(2).table_id
    @my_guests = current_user.guests
    if user_signed_in?
      render
    else
      redirect_to "/"
    end
  end

  def edit
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
    if guest.user_id == current_user.id and table.send(seat) == 0 and guest.table_id == NIL
      guest.update(table_id: table_id)
      table.update(seat.to_sym => guest_id)
      table.update(free: table.free - 1)
      redirect_to "/seating"
    else
      render text: "Not allowed"
    end
  end
end