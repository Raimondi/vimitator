# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vimitator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Israel Chauca", "Barry Arthur"]
  gem.email         = ["israelchauca@gmail.com", "barry.arthur@gmail.com"]
  gem.description   = "Vimitator is a parser for the vimscript (VimL/Ex) file format."
  gem.summary       = "A parser for the vimscript (VimL/Ex) file format."
  gem.homepage      = "http://github.com/Raimondi/vimitator"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vimitator"
  gem.require_paths = ["lib"]
  gem.version       = Vimitator::VERSION

  gem.add_runtime_dependency('racc', "~> 1.4.9")
  gem.add_runtime_dependency('lexr', "~> 0.3.1")
end
