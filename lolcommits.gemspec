# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lolcommits/version"

Gem::Specification.new do |s|
  s.name        = 'lolcommits'
  s.version     = Lolcommits::VERSION
  s.authors     = ['Matthew Rothenberg',    'Matt Hutchinson']
  s.email       = ['mrothenberg@gmail.com', 'matt@hiddenloop.com']
  s.homepage    = 'http://mroth.github.com/lolcommits/'
  s.license     = 'LGPL-3'
  s.summary     = 'Capture webcam image on git commit for lulz.'

  s.description = <<-EOF
  lolcommits takes a snapshot with your webcam every time you git commit code,
  and archives a lolcat style image with it. It's selfies for software
  developers. `git blame` has never been so much fun.
  EOF

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # non-gem dependencies
  s.required_ruby_version = '>= 1.8.7'
  s.requirements << 'imagemagick'
  s.requirements << 'a webcam'

  # core gem dependencies
  s.add_runtime_dependency('mini_magick', '~> 3.5')
  s.add_runtime_dependency('git', '~> 1.2.5')
  s.add_runtime_dependency('choice', '~> 0.1.6')
  s.add_runtime_dependency('launchy', '~> 2.2.0')
  s.add_runtime_dependency('methadone', '~> 1.2.4')
  s.add_runtime_dependency('open4', '~> 1.3.0')

  # development dependencies
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba', '~> 0.5.1')
  s.add_development_dependency('rake', '~> 10.0.2')
  s.add_development_dependency('fivemat', '~> 1.2.1')
  s.add_development_dependency('faker')
  s.add_development_dependency('travis')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('magic_encoding')
  if RUBY_VERSION >= '1.9.2'
    s.add_development_dependency('rubocop', '~> 0.18.1')
  end

  # plugin dependencies
  s.add_runtime_dependency('twitter', '~> 4.8.1')     #twitter
  s.add_runtime_dependency('yam', '~> 2.0.1')         #yammer
  s.add_runtime_dependency('oauth')                   #twitter
  s.add_runtime_dependency('rest-client')             #uploldz
  s.add_runtime_dependency('httmultiparty')           #dot_com
  s.add_runtime_dependency('httparty', "~> 0.11.0")   #dot_com
  s.add_runtime_dependency('json', '~> 1.7.6')        #lolsrv
  s.add_runtime_dependency('mime-types', '~> 1.25')

end
