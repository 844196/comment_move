# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'comment_move/version'

Gem::Specification.new do |spec|
  spec.name          = "comment_move"
  spec.version       = CommentMove::VERSION
  spec.authors       = ["Masaya Takeda"]
  spec.email         = ["844196@gmail.com"]

  spec.summary       = %q{ニコ生過去分のコメントを取得するやつ}
  spec.description   = %q{ニコ生から過去放送分のコメントを取得してきます。ライブラリと簡単なCLIツールを入れておきます。}
  spec.homepage      = "https://github.com/844196"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'nokogiri'
end
