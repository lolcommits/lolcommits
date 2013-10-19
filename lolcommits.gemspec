# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lolcommits/version"

Gem::Specification.new do |s|
  s.name        = "lolcommits"
  s.version     = Lolcommits::VERSION
  s.authors     = ["Matthew Rothenberg"]
  s.email       = ["mrothenberg@gmail.com"]
  s.homepage    = "http://mroth.github.com/lolcommits/"
  s.summary     = %q{Capture webcam image on git commit for lulz.}
  s.description = %q{Takes a snapshot with your webcam every time you git commit code, and archives a lolcat style image with it.}
  s.license     = "LGPL-3"
  s.rubyforge_project = "lolcommits"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # core gem dependencies
  s.add_runtime_dependency('mini_magick', '~> 3.5')
  s.add_runtime_dependency('git', '~> 1.2.5')
  s.add_runtime_dependency('choice', '~> 0.1.6')
  s.add_runtime_dependency('launchy', '~> 2.2.0')
  s.add_runtime_dependency('methadone', '~> 1.2.4')
  s.add_runtime_dependency('open4', '~> 1.3.0')
  s.add_runtime_dependency('activesupport', '~> 3.2.12')

  # development dependencies
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba', '~> 0.5.1')
  s.add_development_dependency('rake',' ~> 10.0.2')
  s.add_development_dependency('fivemat')
  s.add_development_dependency('faker')

  # plugin dependencies
  s.add_runtime_dependency('twitter')                 #twitter
  s.add_runtime_dependency('oauth')                   #twitter
  s.add_runtime_dependency('rest-client')             #uploldz
  s.add_runtime_dependency('httmultiparty')           #dot_com
  s.add_runtime_dependency('json', '~> 1.8.1')        #lolsrv

end
