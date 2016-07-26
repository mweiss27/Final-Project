class RegistrationsController < Devise::RegistrationsController
  def new
  	puts "Reg#new"
    super
  end

  def create
  	puts "Reg#create"
    # add custom create logic here
    super

    @person = Person.new(:first_name => params["user"]["first_name"], :last_name => params["user"]["last_name"])
    @person.save
    current_user.person_id = @person.id
    current_user.save
  end

  def update
  	puts "Reg#update"
    super
  end
end 