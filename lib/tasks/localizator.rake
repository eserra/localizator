namespace :localizator do

  desc "Generate a YAML file with missing translations"
  task :update, [:locale] => :environment do |t, args|
    args.with_defaults(:locale => 'new_locale')
    dl = I18n.default_locale.to_s
    tl = args[:locale]
    filename = "#{Rails.root}/config/locales/#{tl}-missing.yml"
    if File.exists?(filename)
      puts "File 'config/locales/#{tl}-missing.yml' exists."
      puts "Merge it first with 'rake localizer:merge[#{tl}]' or delete it"
    else
      translations = {}
      I18n.load_path.each do |file|
        tree = YAML::parse(File.open(file))
        translations.deep_merge!(tree.transform)
      end
      missing_translations = {tl => Localizator::Helpers::locale_diff(translations[dl], translations[tl])}
      if !missing_translations[tl].empty?
        File.open(filename, 'w') do |f|
          f.puts missing_translations.to_yaml
        end
        puts "Created 'config/locales/#{tl}-missing.yml' with missing translations."
        puts "Edit and merge it back with 'rake localizer:merge[#{tl}]'"
      else
        puts "All keys in locale '#{dl}' are translated!"
      end
    end
  end

  desc "Merge translations into main locale file"
  task :merge , [:locale] => :environment do |t, args|
    args.with_defaults(:locale => 'new_locale')
    tl = args[:locale]
    filename = "#{Rails.root}/config/locales/#{tl}-missing.yml"
    if !File.exists?(filename)
      puts "File 'config/locales/#{tl}-missing.yml' does not exist."
      puts "Create it first with 'rake localizer:update[#{tl}]'"
    else
      translations = {}
      I18n.load_path.each do |file|
        tree = YAML::parse(File.open(file))
        translations.deep_merge!(tree.transform)
      end
      final = {tl => translations[tl]}
      base = "#{Rails.root}/config/locales/#{tl}.yml"
      if File.exists?(base)
        puts "Backing up 'config/locales/#{tl}.yml' to 'config/locales/#{tl}.yml.bak'..."
        FileUtils.cp(base, "#{Rails.root}/config/locales/#{tl}.yml.bak")
      end
      File.open(base, 'w') do |f|
        f.puts final.to_yaml
      end
      puts "Removing 'config/locales/#{tl}-missing.yml'..."
      FileUtils.rm(filename)
      puts "Created 'config/locales/#{tl}.yml' with merged translations."
      puts "Please remove the backup file manually once you are satisfied with the results"
    end
  end

end
