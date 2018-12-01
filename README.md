# Unicorns

[![CI Status](http://img.shields.io/travis/bartekzabicki/Unicorns.svg?style=flat)](https://travis-ci.org/bartekzabicki/Unicorns)
[![Version](https://img.shields.io/cocoapods/v/Unicorns.svg?style=flat)](http://cocoapods.org/pods/Unicorns)
[![License](https://img.shields.io/cocoapods/l/Unicorns.svg?style=flat)](http://cocoapods.org/pods/Unicorns)
[![Platform](https://img.shields.io/cocoapods/p/Unicorns.svg?style=flat)](http://cocoapods.org/pods/Unicorns)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

At least iOS 10

## Documentation:

https://bartekzabicki.github.io/Unicorns/

## Installation

Unicorns is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Unicorns'
```
to fully enjoy @IBDesignable classes, you should also add at the end of your Podfile:

```ruby
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
```

To use Logger globaly add in appDelegate.swift, outside class :
```swift
public typealias Log = Unicorns.Log
```

## Author

bartekzabicki, bartekzabicki@gmail.com

## License

Unicorns is available under the MIT license. See the LICENSE file for more info.
