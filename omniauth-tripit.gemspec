require File.expand_path('../lib/omniauth-tripit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Melanie Gilman"]
  gem.email         = ["melanie.gilman@gmail.com"]
  gem.description   = "Unofficial OmniAuth strategy for TripIt."
  gem.summary       = "Unofficial OmniAuth strategy for TripIt."
  gem.homepage      = "https://github.com/mrgilman/omniauth-tripit"

  gem.files         = Dir['lib/**/*.rb']
  gem.name          = "omniauth-tripit"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Tripit::VERSION

  gem.add_dependency 'omniauth'
  gem.add_dependency 'omniauth-oauth'
end