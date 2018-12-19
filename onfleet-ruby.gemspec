Gem::Specification.new do |s|
  s.name        = 'onfleet-ruby'
  s.version     = '0.1.4'
  s.date        = '2016-04-08'
  s.summary     = 'Onfleet ruby api'
  s.description = "To interact with Onfleet's API"
  s.authors     = ['Nick Wargnier']
  s.email       = 'nick@stylelend.com'
  s.homepage    = 'http://rubygems.org/gems/onfleet-ruby'
  s.license     = 'MIT'

  s.add_dependency('activesupport', '>= 4.2')
  s.add_dependency('rest-client', '~> 2.0')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.3')
  s.add_development_dependency('rspec-its')
  s.add_development_dependency('rubocop', '~> 0.55')
  s.add_development_dependency('webmock', '~> 3.4')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end

