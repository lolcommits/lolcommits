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
  s.description = %q{Capture webcam image on git commit for lulz. Works with Mac OS X and Linux.}

  s.rubyforge_project = "lolcommits"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "rmagick"
  s.add_runtime_dependency "git"
  s.add_runtime_dependency "choice", ">= 0.1.6"
  s.add_runtime_dependency "launchy"
end
