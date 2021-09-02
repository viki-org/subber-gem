lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "subber/version"

Gem::Specification.new do |spec|
  spec.name          = "subber"
  spec.version       = Subber::VERSION
  spec.authors       = ["Viki"]
  spec.email         = ["admin@viki.com"]

  spec.summary       = %q{Subtitle converter}
  spec.description   = %q{Subtitle converter}
  spec.homepage      = "https://github.com/viki-org/subber-gem"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.5'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11"

  # XML parser and builder
  #
  spec.add_dependency "nokogiri", "~> 1.12.3"
end
