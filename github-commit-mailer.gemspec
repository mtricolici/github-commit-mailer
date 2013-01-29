# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github-commit-mailer/version'

Gem::Specification.new do |gem|
  gem.name          = "github-commit-mailer"
  gem.version       = Github::Commit::Mailer::VERSION
  gem.authors       = ["Marcel Tricolici"]
  gem.email         = ["marcel@tricolici.com"]
  gem.description   = %q{gem for pulling changes from a github repository and send mail with differences}
  gem.summary       = %q{gem for pulling changes from a github repository and send mail with differences}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'git-commit-notifier', '0.11.6'
end
