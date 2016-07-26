class RegistrationsController < Devise::RegistrationsController
  def new
  	puts "Reg#new"
    super
  end

  def create
  	puts "Reg#create"
    # add custom create logic here
    super

    @person = Person.new
    current_user.person_id = @person.id
  end

  def update
  	puts "Reg#update"
    super
  end
end 