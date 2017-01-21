module GoogleTranslate
  extend ActiveSupport::Concern

  included do
    require 'htmlentities'
    CONFIG ||= YAML.load(File.read('config/translate.yml'))[Rails.env] 
    ENTITY_DECODER ||= HTMLEntities.new
  end

  def google_translate(text,language)
    #remove any parameters
    a = []
    source_text=text.gsub(/%{\w+}/){|m| a<<m; '00000'}
    conn = Faraday.new CONFIG['host']
    response = conn.post do | req |
      req.headers['X-HTTP-Method-Override']='GET'
      req.body = {'key'=>ENV['GOOGLE_PRIVATE_KEY'],'source'=>'en','target'=>language.to_s,'q'=>source_text}
    end
    result_text=JsonPath.on(response.body,'..translatedText').first|| "#{language} !!!!missing translation"
    decoded_text = ENTITY_DECODER.decode(result_text)
    i=-1
    #put the parameters back again
    decoded_text.gsub('00000'){|m| a[i+=1]}
  end
end
