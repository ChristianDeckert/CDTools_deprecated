# CDTools

## My swift tool box


#### Custom Controls

- CDSpinnerView
- CDKeyboardAwareTextfield 
- CDCircularProgressView

#### Foundation

- DispatchQueue (wrapper for gcd)
```swift
   DispatchQueue(preferredQueue: .PriorityBackground, preferredDelay: 0.4).dispatch {
      print("do work")
   }.then { successful in
      print("done")
   }
```
- Array+CDTools
- CDAppCache
- CDRegEx
- CDFileManager
- NSURL+CDTools
- String+CDTools
- UUID+CDTools

#### UI

- CDBaseViewController
- CDTableViewController (Table model / datasource abstraction)
- CDTableViewCell
- NSLayoutConstraint+CDTools
- UIApplication+CDTools
- UIColor+CDTools
- UIImage+CDTools
- UIImageView+CDTools
- UIStoryboard+CDTools
- UIView+CDTools
- UIViewController+CDTools

## How to

- gem install cocoapods
- pod init
```
platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/ChristianDeckert/Specs.git'

target '<YOUR_TARGET>' do

  use_frameworks!
  pod 'CDTools', '~> 1.0' #Swift 2.2
  pod 'CDTools', '~> 1.5' #Swift 2.3 (work in progress)

end

```
- pod install
