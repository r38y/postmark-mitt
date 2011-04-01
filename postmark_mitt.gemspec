# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'postmark_mitt'

Gem::Specification.new do |s|
  s.name        = "postmark-mitt"
  s.version     = Postmark::Mitt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Randy Schmidt"]
  s.email       = ["randy@forge38.com"]
  s.homepage    = ""
  s.rubyforge_project = "postmark-mitt"
  s.summary     = %q{PROTOTYPE Mitt for incoming email through Postmark}
  s.description = %q{(Prototype) This gem will help you take JSON posted to your app from incoming email through Postmark. It will turn it back into an object with methods to help inspect the contents of the email}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "json"
end
