FactoryGirl.define do
  factory :entity do
    name "MyString"
    wikipedia_entry "MyString"
  end
  Entity.types.each do |entity_type|
    factory entity_type.underscore.downcase.to_sym do
    name {"#{entity_type}::#{SecureRandom.uuid}"}
    wikipedia_entry "MyString"
    end
  end

end
