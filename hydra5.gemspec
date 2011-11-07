# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hydra5/version"

Gem::Specification.new do |s|
  s.name        = "hydra5"
  s.version     = Hydra::VERSION
  s.authors     = ["Ilya Grigorik"]
  s.email       = ["ilya@igvita.com"]
  s.homepage    = "https://github.com/igrigorik/hydra5"
  s.summary     = "Load-balanced (multi-headed) SOCKS5 proxy"
  s.description = s.summary

  s.rubyforge_project = "hydra"

  s.add_dependency "eventmachine", ">= 1.0.0.beta.4"
  s.add_dependency "em-proxy"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
