require 'rails_helper'
describe GoogleTranslate, requires_net: true do
  include GoogleTranslate
  after(:each){I18n.locale = :en}
  it 'should translate some text' do
    result = google_translate('some text with interesting things to say',:de)
    expect(result).to match(/Text mit interessanten/)
  end

  it 'should re-insert parameters' do
    result = google_translate('some text with interesting %{a_parameter} things %{another_parameter} to say',:de)
    expect(result).to match(/interessanten %{a_parameter}/)
  end
end
