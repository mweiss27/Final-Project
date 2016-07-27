module ApplicationHelper
  def get_name_given_person_id person_id
    person = Person.find(person_id)
    "#{person.first_name.capitalize} #{person.last_name.capitalize}"
  end
end
