# CDTools

## My swift tool box


#### Custom Controls

- CDSpinnerView
- CDKeyboardAwareTextfield 

#### Foundation
- CDAppCache
- CDRegEx
- DispatchQueue (wrapper for gcd)
```swift
   DispatchQueue(preferredQueue: .PriorityBackground, preferredDelay: 0.4).dispatch {
      print("do work")
   }.then { successful in
      print("done")
   }
```
- Array+CDTools
- NSURL+CDTools
- String+CDTools
- UUID+CDTools

#### UI

- CDTableViewController (Table Model abstraction)
- CDTableViewCell
- UIStoryboard+CDTools
- NSLayoutConstraint+CDTools
- UIApplication+CDTools
- UIView+CDTools

## How to

- gem install cocoapods
- pod init
```
platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/ChristianDeckert/Specs.git'

target '<YOUR_TARGET>' do

  use_frameworks!
  pod 'CDTools', '~> 1.0'

end

```
- pod install
