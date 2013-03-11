module I18nTools
  class UnusedScanner < Scanner
    def initialize(locale)
      @locale = locale
    end
    
    def results
      used_ones = []

      scan do |key, params|
        used_ones << [@locale, key].join('.')
      end

      defined_ones = I18nTools.extract_i18n_keys(@locale.to_s, I18n.backend.send(:lookup, @locale, ''))

      unused = (defined_ones - used_ones).reject { |key| ignore_keys.any? { |rx| rx =~ key } }.sort
    end
  
  protected
    def ignore_keys
      @ignore_keys ||= File.read(".i18nignore_unused").split("\n").reject { |e| e.strip.blank? || e =~ /^#/ }.collect { |key| Regexp.new(Regexp.escape("#{@locale}.#{key}")) } rescue []
    end
  end
end
