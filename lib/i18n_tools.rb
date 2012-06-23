# require all necessary files here

module I18nTools
  def self.extract_i18n_keys(prefix, object)
    case object
    when Hash
      return prefix if object.keys.include?(:one) && object.keys.include?(:other)
      object.collect do |key, value|
        extract_i18n_keys([prefix, key].join('.'), value)
      end.flatten.compact
    when String
      prefix
    end
  end
end

require File.dirname(__FILE__) + '/i18n_tools/scanner'
require File.dirname(__FILE__) + '/i18n_tools/missing_scanner'
require File.dirname(__FILE__) + '/i18n_tools/unused_scanner'
require File.dirname(__FILE__) + '/i18n_tools/railtie' if defined?(Rails)
