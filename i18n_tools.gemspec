Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "i18n_tools"
  s.version   =   "0.0.5"
  s.date      =   Date.today.strftime('%Y-%m-%d')
  s.author    =   "Thomas Kadauke"
  s.email     =   "tkadauke@imedo.de"
  s.summary   =   "Tasks for extracting missing and unused translations from Rails projects"
  s.files     =   Dir.glob("lib/**/*")

  s.require_path = "lib"
end
