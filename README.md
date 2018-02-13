[![Version](https://img.shields.io/cocoapods/v/PredictIO.svg?style=flat)](http://cocoapods.org/pods/PredictIO)
[![License](https://img.shields.io/cocoapods/l/PredictIO.svg?style=flat)](http://cocoapods.org/pods/PredictIO)
[![Platform](https://img.shields.io/cocoapods/p/PredictIO.svg?style=flat)](http://cocoapods.org/pods/PredictIO)

# Getting Started

## Requirements

* iOS 8.0+
* Xcode 9.2 (Swift 4.0.2)
* Register for a [predict.io API key](http://www.predict.io/service/registration/?level=1)

## Installation (CocoaPods)

Installation via CocoaPods can be accomplished by adding one of the following to your `Podfile`:

```ruby
pod 'PredictIO', '~> 5.3.0'
```

## Installation (Carthage)

Add this to your `Cartfile`:

```
github "predict-io/PredictIO-iOS" ~> 5.3.0
```

And install...

```
$ carthage update --platform iOS  --cache-builds
```

### Link Binary with Libraries

Link your app with the following _System Frameworks_:

* `AdSupport.framework`
* `CoreLocation.framework`
* `CoreMotion.framework`
* `Foundation.framework`
* `SystemConfiguration.framework`
* `libsqlite3.tbd`
* `libz.tbd`

![link-libraries](docs/link-libraries.png)

Once you've run the previous Carthage command you can add the SDK and its dependencies to your app also:

1. `PredictIO.framework`
2. `RxSwift.framework`
3. `SwiftyJSON.framework`

![add-frameworks](docs/add-frameworks.gif)

### Add 'Copy Frameworks' Build Phase

Create a _'New Run Script Phase'_ with the following contents:

```
/usr/local/bin/carthage copy-frameworks
```

![new-run-script](docs/new-run-script.png)

Under *Input Files* add an entry for each of the following items:

1. `$(SRCROOT)/Carthage/Build/iOS/PredictIO.framework`
2. `$(SRCROOT)/Carthage/Build/iOS/RxSwift.framework`
3. `$(SRCROOT)/Carthage/Build/iOS/SwiftyJSON.framework`

# Usage

## Configure your project

### 1. Enable Background Location Updates

Location is used efficiently while in the background, having minimal effect on battery usage. To enable _Background Location Updates_ open your Project Settings, select your App Target, choose _Capabilities_, enable _Background Modes_ and check _Location updates_.

![background-modes](docs/background-modes.png)

> **NOTE** You are required to handle the location permissions request in your application with your own implementation.

### 2. App Usage Descriptions to `Info.plist`

iOS requires you provide the user with a meaningful description of why you will be using their location. It's required that you add the following to your `Info.plist`:

* **Privacy - Location Always Usage Description** (`NSLocationAlwaysUsageDescription`)
* For iOS 11+ **Privacy - Location Always and When In Use Usage Description** (`NSLocationAlwaysAndWhenInUseUsageDescription`)

![usage-descriptions](docs/usage-descriptions.png)

## Integrate the SDK

> **NOTE:** The SDK `start()` method must be called _always_ when your app is launched (from background or foreground launch); a good place to do this would be in your `AppDelegate`, in the [`func applicationDidFinishLaunching(_ application: UIApplication)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623053-applicationdidfinishlaunching) or [`func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application?language=objc) methods.

```swift
// Import the SDK in your AppDelegate
import PredictIO

let apiKey = "<YOUR_API_KEY>"

PredictIO.start(apiKey: "") { (error) in
  switch error {
  case .invalidKey?:
    // Your API key is invalid (incorrect or deactivated)
    print("Invalid API Key")
    
  case .killSwitch?:
    // Kill switch has been enabled to stop the SDK
    print("Kill switch is active")

  case .wifiDisabled?:
    // User has WiFi turned off significantly impacting location accuracy available.
    // This may result in missed events!
    // NOTE: SDK still launches after this error!
    print("WiFi is turned off")

  case .locationPermissionNotDetermined?:
    // Background location permission has not been requested yet.
    // You need to call `requestAlwaysAuthorization()` on your
    // CLLocationManager instance where it makes sense to ask for this
    // permission in your app.
    print("Location permission: not yet determined")

  case .locationPermissionRestricted?:
    // This application is not authorized to use location services.  Due
    // to active restrictions on location services, the user cannot change
    // this status, and may not have personally denied authorization
    print("Location permission: restricted")

  case .locationPermissionWhenInUse?:
    // User has only granted 'When In Use' location permission, and
    // with that it is not possible to determine trips which are made.
    print("Location permission: when in use")

  case .locationPermissionDenied?:
    // User has flat out denied to give any location permission to
    // this application.
    print("Location permission: denied")

  case nil:
    // No error, SDK started with no problems
    print("Successfully started PredictIO SDK!")
  }
}
```

## Webhooks

You can set a webhook URL which you can also receive a copy of the events generated by the predict.io SDK to your own servers. To use this functionality, include code like the following in your app.

```swift
PredictIO.setWebhookURL("https://api.yourapp.com/webhook")
```

## High Power & Low Power

The predict.io SDK comes in two power levels which cater to different requirements of battery consumption and latency of events being detected.

**High Power**

* 5% typical battery usage in 24 hour period
* Events detected within a few minutes
* Mode of Transport detection (coming soon in future beta)
* Intention detection (coming soon in future beta)

```swift
PredictIO.start(apiKey: apiKey, powerLevel: .highPower)
```

**Low Power**

* Less than 1% typical battery usage in 24 hour period
* Events detected with up to 30 min delay
* _No_ Mode of Transport detection
* Intention detection (coming soon in future beta)

> **NOTE**: Low power is the default if no value is set for the `powerLevel` parameter.

```swift
PredictIO.start(apiKey: apiKey, powerLevel: .lowPower)
```

## Events

The predict.io SDK can give you callbacks for the events which are detected for you to integrate with your own app's functionality.

```swift
PredictIO.notify(on: .any) {
  (event: PredictIOTripEvent) in
  // Do something with event 
}
```

```swift
PredictIO.notify(on: .departure) {
    event in
    // Do something when user has left a location
}
```

```swift
PredictIO.notify(on: .arrival) {
    event in
    // Do something when user has arrived at a location
}
```

### `PredictIOTripEvent`

A `PredictIOTripEvent` is the event you will receive that describes attributes of the event which was detected, namely; the *location*, *timestamp* and *type* of the event from the following:

* `.arrival`
* `.departure`
* `.enroute` (High Power only)
* `.still` (High Power only)

```swift
public class PredictIOTripEvent: CustomStringConvertible {
  public let type: PredictIOTripEventType
  public let coordinate: CLLocationCoordinate2D
  public let timestamp: Date
}
```

# Support

Visit our [Help Center]([https://support.predict.io](https://support.predict.io/)), open an Issue or send an email to [support@predict.io](support@predict.io).
