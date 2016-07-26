class RegistrationsController < Devise::RegistrationsController

  def create
    super
    puts "current_user: #{current_user}"
    @person = Person.new(:first_name => params["first_name"], :last_name => params["last_name"])
    @person.save
    puts "current_user: #{current_user}"
    current_user.person_id = @person.id
    current_user.save
  end

  def after_create
    puts "AFTER CREATE"
  end
end 