module I18nTools
  class MissingScanner < Scanner
    def initialize(locale)
      @locale = locale
    end
    
    def results
      missing_ones = []

      scan do |key, params|
        missing_ones << [key, params] unless I18n.backend.send(:lookup, @locale, key)
      end

      result = {}

      missing_ones.each do |key, params|
        current_hash = result
        parts = key.split(".")
        parts[0..-2].each do |part|
          current_hash[part] ||= {}
          current_hash = current_hash[part]
        end
        
        if params.blank?
          content = ""
        else
          keys = []
          
          parsed = params.split(",").map {|x|x.scan(/(:[a-zA-Z0-9_]+)\s*=>\s*(.*)/)}
          parsed.each do |param|
            next if param.blank?
            
            key, value = *param.flatten
            
            keys << "%{#{key.sub(/^:/, '')}} (#{value})"
          end
          
          content = keys.join(", ")
        end
        
        current_hash[parts.last] = content
      end
      
      result
    end
  end
end
