Pod::Spec.new do |s|
  s.name             = 'LoadableResult'
  s.version          = '0.2.1'
  s.summary          = 'LoadableResult is a Result type with a loading state'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
LoadableResult allows services to expose a loading state.
                       DESC

  s.homepage         = 'https://github.com/anconaesselmann/LoadableResult'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ancona-esselmann' => 'axel@anconaesselmann.com' }
  s.source           = { :git => 'https://github.com/anconaesselmann/LoadableResult.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'LoadableResult/Classes/**/*'
end
