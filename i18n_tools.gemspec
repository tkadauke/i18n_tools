Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "i18n_tools"
  s.version   =   "0.1.0"
  s.date      =   Date.today.strftime('%Y-%m-%d')
  s.author    =   "Thomas Kadauke"
  s.email     =   "tkadauke@imedo.de"
  s.summary   =   "Tasks for extracting missing and unused translations from Rails projects"
  s.files     =   Dir.glob("{lib,tasks}/**/*")

  s.require_path = "lib"
  
  s.add_dependency 'ya2yaml'
end
