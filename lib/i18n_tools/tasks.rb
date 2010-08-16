namespace :translations do
  task :setup => :environment do
    require 'i18n_tools'
    
    @locale = (ENV['LOCALE'] || 'en').to_sym
  end
  
  desc 'Detect missing translations'
  task :missing => :setup do
    require 'ya2yaml'
    
    results = I18nTools::MissingScanner.new(@locale).results
    puts({ @locale.to_s => results }.ya2yaml)
  end
  
  desc 'Detect translations that are not used in code'
  task :unused => :setup do
    unused = I18nTools::UnusedScanner.new(@locale).results
    puts unused
  end
end
