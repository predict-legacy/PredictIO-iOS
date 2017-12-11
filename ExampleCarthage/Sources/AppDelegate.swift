//
//  AppDelegate.swift
//  Example
//
//  Created by Kieran Graham on 11/08/2017.
//  Copyright © 2017 predict.io. All rights reserved.
//

import UIKit
import PredictIO
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let locationManager = CLLocationManager()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    PredictIO.instance.start(apiKey: "") { (error) in
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

      case .locationPermissionRestricted:
        // This application is not authorized to use location services.  Due
        // to active restrictions on location services, the user cannot change
        // this status, and may not have personally denied authorization
        print("Location permission: restricted")

      case .locationPermissionWhenInUse:
        // User has only granted 'When In Use' location permission, and
        // with that it is not possible to determine trips which are made.
        print("Location permission: when in use")

      case .locationPermissionDenied:
        // User has flat out denied to give any location permission to
        // this application.
        print("Location permission: denied")

      case nil:
        // No error, SDK started with no problems
        print("Successfully started PredictIO SDK!")
      }
    }
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

