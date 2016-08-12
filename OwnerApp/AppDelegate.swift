//
//  AppDelegate.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        DropDown.startListeningToKeyboard()
        
        registerForPushNotification(application)
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            print(aps)
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 100.0
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - AppDelegate
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
    }
    // Background mode notification
    //func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //
    //    }
    
    //When the user accepts or declines push notification permissions or has already made that selection in the past, it gets called.
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings != .None {
            application.registerForRemoteNotifications()
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
//    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
//        // 1
//        //let aps = userInfo["aps"] as! [String: AnyObject]
//        
//        // 4
//        completionHandler()
//    }
    
    // MARK: - Internal methods
    func registerForPushNotification(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.location?.coordinate == nil {
            return
        }
        
        let lat = NSNumber(double: (manager.location?.coordinate.latitude)!)
        let lon = NSNumber(double: (manager.location?.coordinate.longitude)!)
        let nc = NSNotificationCenter.defaultCenter()
        
        let location = [
            "latitude": lat,
            "longitude": lon
        ]
        nc.postNotificationName(NOTIFICATION_LOCATION, object: nil, userInfo: location)
    }
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }


}

