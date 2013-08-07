require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new "Ruby4Misawa", Misawa::VERSION do |spec|
  spec.summary     = 'A scraping library for Jigoku no Misawa'
  spec.homepage    = 'https://github.com/namusyaka/Ruby4Misawa'
  spec.authors     = ['namusyaka']
  spec.email       = 'namusyaka@gmail.com'
  spec.files       = `git ls-files`.split("\n") - %w(.gitignore)
  spec.test_files  = spec.files.select { |path| path =~ /^spec\/.*_spec\.rb/ }
  spec.license     = "MIT"

  spec.add_dependency('nokogiri')
end
