require 'i18n_tools'
require 'rails'

module I18nTools
  class Railtie < Rails::Railtie
    railtie_name :i18n_tools

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../../tasks/*.rake')].each { |f| load f }
    end
  end
end
