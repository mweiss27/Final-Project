module ApplicationHelper
  class String
    def truncate(max)
      length > max ? "#{self[0...max]}..." : self
    end
  end
  
  def get_name_given_person_id person_id
    person = Person.find(person_id)
    "#{person.first_name.capitalize.truncate(15)} #{person.last_name.capitalize.truncate(15)}"
  end
end
