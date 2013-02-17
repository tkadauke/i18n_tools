module I18nTools
  class Scanner
    VIEW_REGEXPS = [/[^\w]t\ *\(\"(.*?)\".*?\)/, /[^\w]t\ *\(\'(.*?)\'.*?\)/, /[^\w]t\ *\(\:([^\,\ ]+).*\)/, /[^\w]t\ \"(.*)\"/, /[^\w]t\ \'(.*)\'/, /[^\w]t\ +\:([^\,\ ]+)/]
    CODE_REGEXPS = VIEW_REGEXPS
    
    cattr_accessor :file_types
    self.file_types = ['controllers', 'helpers', 'models']

  protected
    def scan(&block)
      scan_views(&block)
      scan_code(&block)
    end
    
  private
    def scan_views(&block)
      Dir['app/views/**/*.erb', 'app/views/**/*.rhtml'].each do |filename|
        next if ignores.any? { |r| filename =~ r }

        content = File.read(filename)
        VIEW_REGEXPS.each do |view_regexp|
          content.scan(view_regexp) do |match|
            key = match.first
            next if key =~ /\#\{/
            if key =~ /^\./
              namespace = filename.gsub('app/views/', '').gsub('.html.erb', '').gsub('/', '.')
              key = (namespace + key).split('.').collect { |part| part.gsub(/^\_/, '') }.join('.')
            end
            yield key
          end
        end
      end
    end
    
    def scan_code(&block)
      Dir["lib/**/*.rb", *self.class.file_types.collect { |t| "app/#{t}/**/*.rb" }].each do |filename|
        next if ignores.any? { |r| filename =~ r }

        content = File.read(filename)
        CODE_REGEXPS.each do |code_regexp|
          content.scan(code_regexp) do |match|
            key = match.first
            next if key =~ /\#\{/
            yield key
          end
        end
      end
    end
    
    def ignores
      @ignores ||= File.read(".i18nignore").split("\n").reject { |e| e.strip.blank? || e =~ /^#/ }.collect { |i| Regexp.new(i) } rescue []
    end
  end
end
