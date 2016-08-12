//
//  BWGTokenManager.swift
//  OwnerApp
//
//  Created by Star Developer on 4/13/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGTokenManager: NSObject {
    static let sharedInstance = BWGTokenManager()
    var tokenEndpoint: String = ""
    var manager: Manager
    var mobileClientSecret: String
    var mobileClientId: String
    var accessToken: String
    var refreshToken: String
    var m_username: String
    var m_password: String
    override init() {
        
        mobileClientId = ""
        mobileClientSecret = ""
        accessToken = ""
        refreshToken = ""
        m_username = ""
        m_password = ""
        //Self signed Certificate
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        manager = Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    
    func requestTokenEndpointWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForEntry()
        print("API URL : " + strUrl)
        
        manager.request(.GET, strUrl)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    //print(json)
                    print("Success: Got token endpoint.")
                    self.tokenEndpoint = json["_links"]["tokenEndpoint"]["href"].stringValue
                    self.mobileClientId = json["mobileClientId"].stringValue
                    self.mobileClientSecret = json["mobileClientSecret"].stringValue
                    
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                }
        }
    }
    func requestAccessToken(callback: (status: ERROR_CODE)->Void)
    {
        print("API URL : " + self.tokenEndpoint)
        // set up the base64-encoded credentials
        let loginString = NSString(format: "%@:%@", self.mobileClientId, self.mobileClientSecret)
        let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        let params = [
            "grant_type": "password",
            "scope": "openid user_name",
            "username": self.m_username,
            "password": self.m_password
        ]
        let headers = [
            "Authorization": "Basic \(base64LoginString)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        manager.request(.POST, self.tokenEndpoint, parameters: params, encoding: .URL, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    //print(json)
                    self.accessToken = json["access_token"].stringValue
                    self.refreshToken = json["refresh_token"].stringValue
                    print("Success: \(self.accessToken)")
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("Login error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                }
        }
    }
}
