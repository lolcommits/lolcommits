# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lolcommits/version"

Gem::Specification.new do |s|
  s.name        = "lolcommits"
  s.version     = Lolcommits::VERSION
  s.authors     = ["Matthew Rothenberg"]
  s.email       = ["mrothenberg@gmail.com"]
  s.homepage    = "http://github.com/mroth/lolcommits"
  s.summary     = %q{Capture webcam image on git commit for lulz.}
  s.description = %q{Takes a snapshot with your Mac's built-in iSight/FaceTime webcam (or any working webcam on Linux or Windows) every time you git commit code, and archives a lolcat style image with it.}
  s.license     = "LGPL-3"
  s.rubyforge_project = "lolcommits"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rmagick', '~> 2.13.1')
  s.add_runtime_dependency('git', '~> 1.2.5')
  s.add_runtime_dependency('choice', '~> 0.1.6')
  s.add_runtime_dependency('launchy')

  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('rake','~> 0.9.2')
  s.add_dependency('methadone', '~>1.2.1')
  s.add_runtime_dependency('httmultiparty')
  s.add_runtime_dependency('active_support')
end
