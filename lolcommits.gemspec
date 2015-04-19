# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'lolcommits/version'

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
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  # non-gem dependencies
  s.required_ruby_version = '>= 1.8.7'
  s.requirements << 'imagemagick'
  s.requirements << 'a webcam'

  # hold back upgrading (and why)
  s.add_runtime_dependency('rest-client', '~> 1.6.7') # yam gem requires uses this older version
  s.add_runtime_dependency('mini_magick', '~> 3.8.1') # ~> 4+ fails with JRuby
  s.add_runtime_dependency('mime-types', '~> 1.25')   # ~> 2+ requires Ruby >= 1.9.2
  s.add_runtime_dependency('httparty', '~> 0.11.0')   # ~> 0.13+ requires Ruby >= 1.9.3
  s.add_runtime_dependency('git', '=1.2.8')           # ~> 1.2.9 has issues with Ruby 1.8.7
  s.add_development_dependency('cucumber', '=1.3.19') # ~> 2+ requries Ruby >= 1.9.3

  # core
  s.add_runtime_dependency('choice', '~> 0.1.6')
  s.add_runtime_dependency('launchy', '~> 2.4.3')
  s.add_runtime_dependency('methadone', '~> 1.8.0')
  s.add_runtime_dependency('open4', '~> 1.3.4')

  # plugin gems
  s.add_runtime_dependency('twitter', '~> 5.13.0')       # twitter
  s.add_runtime_dependency('oauth', '~> 0.4.7')          # twitter oauth
  s.add_runtime_dependency('yam', '~> 2.4.0')            # yammer
  s.add_runtime_dependency('json', '~> 1.8.1')           # lolsrv
  s.add_runtime_dependency('httmultiparty', '~> 0.3.16') # dot_com

  # development gems
  s.add_development_dependency('fivemat', '~> 1.3.1')
  s.add_development_dependency('rdoc', '~> 4.2.0')
  s.add_development_dependency('aruba', '~> 0.6.2')
  s.add_development_dependency('rake', '~> 10.4.2')
  s.add_development_dependency('ffaker', '~> 1.25.0')
  s.add_development_dependency('coveralls', '~> 0.7.2')
  s.add_development_dependency('minitest', '~> 5.5.1')

  if RUBY_VERSION >= '1.9.3'
    s.add_development_dependency('travis', '~> 1.7.4')
    s.add_development_dependency('rubocop', '~> 0.30')
  end
end
