//
//  BWGLocalStorageManager.swift
//  OwnerApp
//
//  Created by Adam on 4/3/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class BWGLocalStorageManager: NSObject {
    static let GLOBAL_PREFIX = "GLOBAL"
    static func saveObject(obj: AnyObject, key: String)
    {
        let strKey = String.localizedStringWithFormat("%@_%@", BWGUserManager.sharedInstance.m_strUsername, key)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(obj, forKey: strKey)
        userDefaults.synchronize()
    }
    static func saveGlobalObject(obj: AnyObject, key: NSString)
    {
        let strKey = String.localizedStringWithFormat("%@_%@", GLOBAL_PREFIX,key)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(obj, forKey: strKey)
        userDefaults.synchronize()
    }
    static func loadObjectWithKey(key: String)->AnyObject?
    {
        let strKey = String.localizedStringWithFormat("%@_%@", BWGUserManager.sharedInstance.m_strUsername, key)
        return NSUserDefaults.standardUserDefaults().objectForKey(strKey)!
        
    }
    static func loadGlobalObjectWithKey(key: String)->AnyObject?
    {
        let strKey = String.localizedStringWithFormat("%@_%@", GLOBAL_PREFIX,key)
        if let obj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(strKey) {
            return obj;
        }
        return nil
    }
    static func removeObjectWithKey(key: String)
    {
        let strKey = String.localizedStringWithFormat("%@_%@", BWGUserManager.sharedInstance.m_strUsername, key)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(strKey)
        userDefaults.synchronize()
    }
    static func removeGlobalObjectWithKey(key: String)
    {
        let strKey = String.localizedStringWithFormat("%@_%@", GLOBAL_PREFIX,key)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(strKey)
        userDefaults.synchronize()
    }
}
