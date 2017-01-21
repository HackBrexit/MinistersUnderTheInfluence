class MeansOfInfluenceDecorator < Draper::Decorator
  delegate_all

  def date_string
    "#{Date::ABBR_MONTHNAMES[month]} #{year}"
  end

  def government_side
    influence_government_office_people.map do |ip|
      government_office_name = ip.government_office.try(:name)
      person_name = ip.person.try(:name)
      [government_office_name, person_name].compact.join ": "
    end.join(',')
  end

  def organisation_side
     influence_organisation_people.map do |ip|
       if ip.person
         "#{ip.organisation.name}: #{ip.person.name}"
       else
         ip.organisation.name
       end
     end.join(',')
  end
end
