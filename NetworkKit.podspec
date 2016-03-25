Pod::Spec.new do |s|
  s.name             = "NetworkKit"
  s.version          = "1.3.2"
  s.summary          = "Lightweight Networking and Parsing framework made for iOS, Mac, WatchOS and tvOS"

  s.description      = "A lightweight iOS, Mac and Watch OS framework that makes networking and parsing super simple. Uses the open-sourced JSONHelper with functional parsing. For networking the library supports basic GET, POST, DELETE HTTP requests."
  s.homepage         = "https://github.com/imex94/NetworkKit"
  s.license          = 'MIT'
  s.author           = { "Alex Telek" => "imex94@gmail.com" }
  s.source           = { :git => "https://github.com/imex94/NetworkKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexmtk'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true

  s.source_files = 'NetworkKit/*.swift'
end
