//
//  BWGUrlManager.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//

//import Cocoa
import UIKit
import Alamofire
import SwiftyJSON

class BWGUrlManager: NSObject {

    // MARK: - Login, Register
    class func getEndpointForWhoAmI()->String
    {
        return BASE_URL + "/auth/whoami"
    }
    class func getEndpointForEntry()->String
    {
        let strUrl = ENTRY_URL
        return strUrl
    }

    class func getEndpointForLogin()->String
    {
        return BASE_URL + "/auth/login"
    }
    class func getEndpointForRegister()->String
    {
        return BASE_URL + "/registerSpaToUser"
    }
    class func getEndpointForUnregister()->String
    {
        return BASE_URL + "/registerSpaToUser"
    }
    class func getEndpointForTermsAndConditions()->String
    {
        return BASE_URL + "/termsandconditions"
    }
    class func getEndpointForFindMostRecentTAC()->String
    {
        return BASE_URL + "/tac/search/findMostRecent"
    }
    class func getEndpointForFindCurrentUserAgreement(userId:String)->String
    {
        return BASE_URL + "/tac/search/findCurrentUserAgreement?userId=" + userId;
    }
    class func getEndpointForAgreeTAC()->String
    {
        return BASE_URL + "/tac/agree"
    }
    
    class func getEndpointForUpdateAccount(userId: String)->String
    {
        //return BASE_URL + "/users/" + userId
        return BASE_URL + "/user-registration/" + userId
    }
    class func getEndpointForUserFindByUsername(username:String)->String
    {
        return BASE_URL + "/users/search/findByUsername?username=" + username
    }
    
    // MARK: - SpaManager
    class func getEndpointForSpaFindByUsername(username:String)->String
    {
        return BASE_URL + "/spas/search/findByUsername?username=" + username
    }
    
    class func getEndpointForSpaSetDesiredTemp(spaId: String)->String
    {
        return BASE_URL + "/control/" + spaId + "/setDesiredTemp"
    }
    
    class func getEndpointForSpaSetFilterCycleIntervals(spaId: String)->String
    {
        return BASE_URL + "/control/" + spaId + "/setFilterCycleIntervals"
    }
    class func getEndpointForSpaSetControlState(spaId: String, componentType: String)->String
    {
        return BASE_URL + "/control/" + spaId + "/set" + componentType + "State"
    }
    class func getEndpointForSpaDetails(spaId: String)->String
    {
        return BASE_URL + "/spas/" + spaId
    }
    // MARK: - Presets story: MySpaSettings API
    class func getEndpointForSpaSettings(spaId: String)->String
    {
        return BASE_URL + "/spas/" + spaId + "/recipes"
    }
    class func getEndpointForRunSpaRecipe(spaId: String, id: String)->String
    {
        return BASE_URL + "/spas/" + spaId + "/recipes/" + id + "/run"
    }
    class func getEndpointForSpaRecipe(spaId:String, id: String)->String
    {
        return BASE_URL + "/spas/" + spaId + "/recipes/" + id
    }
    
}
