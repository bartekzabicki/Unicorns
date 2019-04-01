#
# Be sure to run `pod lib lint Unicorns.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# Updating pod: pod trunk push Unicorns.podspec --swift-version="5.0"
# Validating pod: pod lib lint Unicorns.podspec --swift-version="5.0"

Pod::Spec.new do |s|
  s.name             = 'Unicorns'
  s.version          = '0.2.1'
  s.summary          = 'Simple yet useful set of extensions/helpers/controls.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This pod is a set of useful little thinks for swift that will make your life better ;)'

  s.homepage         = 'https://github.com/bartekzabicki/Unicorns'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bartekzabicki' => 'bartekzabicki@gmail.com' }
  s.source           = { :git => 'https://github.com/bartekzabicki/Unicorns.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Unicorns/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Unicorns' => ['Unicorns/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
end
