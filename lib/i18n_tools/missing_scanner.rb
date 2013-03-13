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
        
        content = suggestion_for_key(parts.last) || ""
        
        if content.blank?
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
        end
        
        current_hash[parts.last] = content
      end
      
      result
    end
    
    def suggestion_for_key(key)
      root = I18n.backend.send(:lookup, @locale, "")
      
      candidates = find_key(key.to_sym, root)
      
      most_common_value(candidates) unless candidates.empty?
    end
  
  private
    def find_key(key, hash)
      if hash[key] && hash[key].is_a?(String)
        [hash[key]]
      else
        result = []
        hash.each do |_, value|
          result += find_key(key, value) if value.is_a?(Hash)
        end
        result
      end
    end
    
    def most_common_value(a)
      a.group_by do |e|
        e
      end.values.max_by(&:size).first
    end
  end
end
