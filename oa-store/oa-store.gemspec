require 'rubygems'

version = File.open(File.dirname(__FILE__) + '/../VERSION', 'r').read.strip

Gem::Specification.new do |gem|
  gem.name = "oa-store"
  gem.version = version
  gem.summary = %Q{Storage for OmniAuth strategies.}
  gem.description = %Q{Storage for OmniAuth strategies.}
  gem.email = "randall@clickpass.com"
  gem.homepage = "http://github.com/rjspotter/omniauth"
  gem.authors = ["Randall Potter"]
  
  gem.files = Dir.glob("{lib}/**/*") + %w(README.rdoc LICENSE)
  
  gem.add_dependency  'oa-core',    version
  gem.add_dependency  'rack-client','~> 0.3.0'
  
  eval File.read(File.join(File.dirname(__FILE__), '../development_dependencies.rb'))
end
