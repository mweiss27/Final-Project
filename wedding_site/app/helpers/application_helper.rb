module ApplicationHelper
  # Truncate a string and add '...' in the end
  class String
    def truncate(max)
      length > max ? "#{self[0...max]}..." : self
    end
  end
  
  # Date: 07/26/2016
  # Author: Ziman Ling
  # Takes an id of a person as paramter, returns the the first name appended by the last name, truncate the name if it is too long
  def get_name_given_person_id person_id
    person = Person.find(person_id)
    "#{person.first_name.capitalize.truncate(15)} #{person.last_name.capitalize.truncate(15)}"
  end
end
