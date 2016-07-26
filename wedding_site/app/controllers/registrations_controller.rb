class RegistrationsController < Devise::RegistrationsController

  def create
    super
    @person = Person.new(:first_name => params["first_name"], :last_name => params["last_name"])
    @person.save
    current_user.person_id = @person.id
    current_user.save
  end

end 