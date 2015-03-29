# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vigenere/version'

Gem::Specification.new do |spec|
  spec.name          = 'email-vigenere'
  spec.version       =  VIGENERE::VERSION
  spec.authors       = ['Fundbase']
  spec.email         = ['support@fundbase.com']
  spec.summary       = %q{ Encoding/Decoding text with Vigenere Cipher}
  spec.description   = %q{Easily Encode/Decode text with Vigenere Cipher}
  spec.homepage      = 'https://github.com/Fundbase/vigenere'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
