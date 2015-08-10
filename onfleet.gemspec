Gem::Specification.new do |s|
  s.name        = 'onfleet'
  s.version     = '0.0.0'
  s.date        = '2015-08-03'
  s.summary     = "Onfleet ruby api"
  s.description = "To interact with Onfleet's API"
  s.authors     = ["Nick Wargnier"]
  s.email       = 'nick@stylelend.com'
  s.homepage    =
    'http://rubygems.org/gems/onfleet'
  s.license     = 'MIT'

  s.add_dependency('rest-client', '~> 1.4')

  s.add_development_dependency "rspec"


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
