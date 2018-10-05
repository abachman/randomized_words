
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "randomized_words/version"

Gem::Specification.new do |spec|
  spec.name          = "randomized_words"
  spec.version       = RandomizedWords::VERSION
  spec.authors       = ["Adam Bachman"]
  spec.email         = ["adam.bachman@gmail.com"]

  spec.summary       = %q{Generate random, pronounceable words}
  spec.description   = %q{Use the Markov chain generation technique to generate random pronounceable words}
  spec.homepage      = "https://github.com/abachman/randomized_words"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
