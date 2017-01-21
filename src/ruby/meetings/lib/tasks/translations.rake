require_relative '../google_translate'
include GoogleTranslate

namespace :google_translate do
  desc "translate FROM=file TO=file"
  task file: :environment do
    source = YAML.load(File.read(ENV['FROM']))
    dest   = YAML.load(File.read(ENV['TO']))
    dest_language = dest.keys.first
    dest[dest_language]= check_missing_translations(source.values.first,(dest[dest_language]||{}),dest_language)
    File.open("#{ENV['TO']}",'w'){|f| f.write(dest.to_yaml)}
  end

  desc "create a new translation file FROM=file TO=destination language"
  task new_file: :environment do
    source = YAML.load(File.read("config/locales/#{ENV['FROM']}.yml"))
    dest_language = ENV['TO']
    dest = Hash.new
    dest[dest_language]= check_missing_translations(source.values.first,{},dest_language)
    ap dest
    File.open("config/locales/#{ENV['FROM'].gsub('en',dest_language)}.yml",'w'){|f| f.write(dest.to_yaml)}
  end

  desc "update translation files FROM=file"
  task update_files: :environment do
    source = YAML.load(File.read("config/locales/#{ENV['FROM']}.en.yml"))
    files = Dir.glob("config/locales/#{ENV['FROM']}*").reject{|d| d=~/\.en\./}
    files.each do | dest_file |
      locale = /\.(\w{2})\./.match(dest_file)[1]
      ap locale
      dest = YAML.load(File.read(dest_file))
      dest[locale]= check_missing_translations(source['en'],dest[locale],locale)
      File.open(dest_file,'w'){|f| f.write(dest.to_yaml)}
    end
  end

  desc "create translation files FROM=file TO=destination languages"
  task new_files: :environment do
    source = YAML.load(File.read("config/locales/#{ENV['FROM']}.en.yml"))
    ENV['TO'].split(/ |,/).each do | dest_language |
      dest = Hash.new
      dest[dest_language]= check_missing_translations(source.values.first,{},dest_language)
      ap dest
      File.open("config/locales/#{ENV['FROM']}.#{dest_language}.yml",'w'){|f| f.write(dest.to_yaml)}
    end
  end
end


def check_missing_translations(source,dest,dest_language)
  if source.is_a?(Hash)
    source.each_pair do | key, value |
      if (!dest[key]) || (ENV['FIX_PARAMETERS'] && value.is_a?(String) && value =~ /%{\w+}/)
        puts source[key]
        if value.is_a?(Hash)
          dest[key] = Hash.new
        else
          if source[key] || (ENV['FIX_PARAMETERS'] && source[key].is_a?(String) && source[key] =~ /%{\w+}/)
            translation = google_translate(source[key],dest_language)
            puts translation 
            dest[key] = translation
          else
            raise "#{key} value is missing from the source"
          end
        end
      end
      check_missing_translations(source[key],dest[key],dest_language)
    end  
  end
  dest
end

