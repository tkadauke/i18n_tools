require 'i18n_tools'
require 'rails'

module I18nTools
  class Railtie < Rails::Railtie
    railtie_name :i18n_tools

    rake_tasks do
      require 'i18n_tools/tasks'
    end
  end
end
