$:.push File.expand_path('../lib', __FILE__)

require 'user_authentication/version'

Gem::Specification.new do |s|
  s.name        = 'user_authentication'
  s.version     = UserAuthentication::VERSION
  s.authors     = ['Sujoy Gupta']
  s.email       = ['sujoyg@gmail.com']
  s.homepage    = 'http://github.com/sujoyg/user_authentication'
  s.summary     = 'A rails engine for email and password based account authentication.'
  s.description = 'A rails engine for email and password based account authentication.'
  s.license     = 'MIT'
  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile']

  s.add_dependency 'rails', '~> 4.1'
  s.add_dependency 'bcrypt', '~> 3.1'

  s.add_development_dependency 'capybara', '2.4.4'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'specstar-controllers', '~> 0.1'
  s.add_development_dependency 'specstar-models', '~> 0.2'
  s.add_development_dependency 'specstar-support-random', '~> 0.1'
  s.add_development_dependency 'sqlite3'
end
