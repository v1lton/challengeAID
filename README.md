# Marvel Challenge

iOS pure-Swift app created for a programming challenge. I used UIKit and the Marvel Developer API for searching for Marvel Comics.

## Requirements

* Xcode 13.1
* iOS 15.0 +
* Swift 5.0

## Architecture

The app architecture were build considering oriented programming concepts. This app is using MVVM, with Coordinator pattern to navigate between screens. All views are made programmatically using the UIKit framework and work in light and dark modes. Data is persisted with Core Data, the networking layer was created using URLSession.

## Dependencies

Some dependencies were used to help build this app with Swift Package Manager:

* RxSwift 6.5.0
* SDWebImage 5.13.0
* Swinject 2.8.1
