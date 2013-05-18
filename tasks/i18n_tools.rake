namespace :translations do
  task :clear do
    require 'i18n'
    I18n.load_path.clear
  end
  
  task :load do
    if Rake::Task.task_defined?("environment")
      Rake::Task["environment"].invoke
    else
      require 'i18n'
      
      I18n.load_path << Dir[File.join('locales', '*.yml')]
      I18n.load_path << Dir[File.join('config', 'locales', '*.yml')]
    end
    
    require 'i18n_tools'
    
    @locale = (ENV['LOCALE'] || 'en').to_sym
  end
  
  desc 'Detect missing translations'
  task :missing => :load do
    require 'ya2yaml'
    
    results = I18nTools::MissingScanner.new(@locale).results
    puts({ @locale.to_s => results }.ya2yaml)
  end
  
  desc 'Detect translations that are not used in code'
  task :unused => [:clear, :load] do
    unused = I18nTools::UnusedScanner.new(@locale).results
    puts unused
  end
  
  desc 'Merge in new translations'
  task :merge do
    require 'yaml'
    require 'ya2yaml'
    require 'deep_merge/rails_compat'
    
    Dir.glob("config/locales/*.yml").each do |file|
      content = File.read(file)
      parts = content.split("---").map { |part| YAML.load(part) }
      result = parts.inject({}) { |result, hash| result.deeper_merge(hash) }
      File.open(file, 'w') { |f| f.puts(result.ya2yaml) }
    end
  end
end
