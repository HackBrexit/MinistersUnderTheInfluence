FactoryGirl.define do
  factory :means_of_influence do
    day 1
    month 1
    year 1
    purpose "MyString"
    type_of_hospitality "MyString"
    gift "MyString"
    value 1
  end
  MeansOfInfluence.types.each do |mof_type|
    factory mof_type.underscore.downcase.to_sym do
    day 1
    month 1
    year 1
    purpose "MyString"
    type_of_hospitality "MyString"
    gift "MyString"
    value 1
    end
  end
end
