module I18nTools
  class MissingScanner < Scanner
    def initialize(locale)
      @locale = locale
    end
    
    def results
      missing_ones = []

      scan do |key|
        missing_ones << key unless I18n.backend.send(:lookup, @locale, key)
      end

      result = {}

      missing_ones.each do |key|
        current_hash = result
        parts = key.split(".")
        parts[0..-2].each do |part|
          current_hash[part] ||= {}
          current_hash = current_hash[part]
        end

        current_hash[parts.last] = ""
      end
    end
  end
end
