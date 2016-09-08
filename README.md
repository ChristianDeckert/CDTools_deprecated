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
