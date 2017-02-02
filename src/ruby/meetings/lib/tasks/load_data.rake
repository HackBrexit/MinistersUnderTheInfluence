require 'csv'

desc 'seed with ministerial meeting data'
task seed_ministerial_meeting_data: :environment do
  clear_all_data
  # open each file in turn
  Dir.glob("db/seed_data/bmmeetings*.csv").each do |file_name|
    year_number = /(\d{4})/.match(file_name)[1].to_i
    puts file_name
    sf = SourceFile.create(location: file_name, uri: file_name)
    line_number = 0
    CSV.open(file_name,headers: true).each do | row |
      break unless row['Minister']
      line_number += 1
      office_name  = row['Minister'].split(',')[0]
      person_name  = row['Minister'].split(',')[1]
      month_number = Date::ABBR_MONTHNAMES.index(row['Date']) || Date::MONTHNAMES.index(row['Date'])
      year_number  = 2013
      purpose_of_meeting = row['Purpose of meeting']
      meeting = Meeting.create(month:month_number,
                               year: year_number,
                               purpose: purpose_of_meeting,
                               source_file: sf,
                               source_file_line_number: line_number)
      g_office = GovernmentOffice.find_or_create_by(name: office_name.strip)
      person = Person.find_or_create_by(name: person_name.strip)
      InfluenceGovernmentOfficePerson.create(means_of_influence_id:meeting.id, person_id: person.id, office_id: g_office.id)
      row['Name of Organisation'].split(/;|,/).each do | org_name |
        organisation = Organisation.find_or_create_by(name: org_name.strip)
        InfluenceOrganisationPerson.create(means_of_influence_id:meeting.id, office_id: organisation.id)
      end
    end
  end
end

def clear_all_data
  InfluenceOfficePerson.destroy_all
  Entity.destroy_all
  MeansOfInfluence.destroy_all
end
