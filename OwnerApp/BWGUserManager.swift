//
//  BWGUserManager.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGUserManager: NSObject {
    static let sharedInstance = BWGUserManager()
    
    var m_strFirstName: String
    var m_strLastName: String
    var m_strUsername: String
    var m_strPassword: String
    var m_strEmail: String
    var m_strId: String
    var m_strPhone: String
    var m_strAddress1: String
    var m_strAddress2: String
    
    var m_strCity: String
    var m_strZipcode: String
    var m_strState: String
    var m_strCountry: String
    var m_strDealerId: String
    var m_strOemId: String
    var m_arrRoles = [String]()
    var m_dictAddress = [String: String]()
    
    var manager: Manager
    
    override init() {
       
        self.m_strFirstName = ""
        self.m_strLastName = ""
        self.m_strUsername = ""
        self.m_strPassword = ""
        self.m_strEmail = ""
        self.m_strId = ""
        self.m_strPhone = ""
        self.m_strAddress1 = ""
        self.m_strAddress2 = ""
        self.m_strCity = ""
        self.m_strZipcode = ""
        self.m_strState = ""
        self.m_strCountry = ""
        self.m_strDealerId = ""
        self.m_strOemId = ""
        //Trust policy for self-signed Certificate
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        manager = Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        //super.init()
    }
    func initializeManager() {
        self.m_strFirstName = ""
        self.m_strLastName = ""
        self.m_strUsername = ""
        self.m_strPassword = ""
        self.m_strEmail = ""
        self.m_strId = ""
        self.m_strPhone = ""
        self.m_strAddress1 = ""
        self.m_strAddress2 = ""
        self.m_strCity = ""
        self.m_strZipcode = ""
        self.m_strState = ""
        self.m_strCountry = ""
        self.m_strDealerId = ""
        self.m_strOemId = ""
        self.m_dictAddress.removeAll()
        self.m_arrRoles.removeAll()
    }
    func saveUserLoginToLocalStorage()
    {
        let userLogin:NSDictionary = [
            "username": m_strUsername,
            "password": m_strPassword
        ]
        BWGLocalStorageManager.saveGlobalObject(userLogin, key: LOCALSTORAGE_USERCREDENTIAL)
    }
    func loadUserLoginFromLocalStorage()->Bool
    {
        if let userLogin = BWGLocalStorageManager.loadGlobalObjectWithKey(LOCALSTORAGE_USERCREDENTIAL) as? NSDictionary {
            if let username = userLogin.objectForKey("username") as? String {
                self.m_strUsername = username
                self.m_strPassword = userLogin.objectForKey("password") as! String
                return true
            }
        }
        return false
    }
    func removeUserLoginFromLocalStorage()
    {
        BWGLocalStorageManager.removeGlobalObjectWithKey(LOCALSTORAGE_USERCREDENTIAL)
    }
    
    // MARK: - REST API call
//    func requestLoginWithCallback(callback: (status: ERROR_CODE)->Void)
//    {
//        let strUrl = BWGUrlManager.getEndpointForLogin()
//        print("API URL : " + strUrl)
//        let params = [
//            "username": m_strUsername,
//            "password": m_strPassword
//        ]
//        let headers = [
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
//        manager.request(.POST, strUrl, parameters: params, encoding: .JSON, headers: headers)
//            .responseJSON { response in
//                switch response.result{
//                case .Success(let data):
//                    let json = JSON(data)
//                    if let error = json["error"].string {
//                        print(error)
//                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
//                    } else {
//                        self.m_strId = json["_id"].stringValue
//                        self.m_strEmail = json["email"].stringValue
//                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
//                    }
//                    
//                case .Failure(let error):
//                    print("Login error: \(error)")
//                    callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
//                }
//            }
//            .responseString { (response) in
//                print(response.response)
//            }
//    }
    func requestUpdateAccountWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForUpdateAccount(self.m_strId)
        print("API URL : " + strUrl)
        let params:[String : AnyObject] = [
            "firstName": m_strFirstName,
            "lastName":  m_strLastName,
            "address":  [
                "address1": m_strAddress1,
                "address2": m_strAddress2,
                "city": m_strCity,
                "state": m_strState,
                "country": m_strCountry,
                "zip": m_strZipcode
            ],
            "phone": m_strPhone,
            "dealerId": m_strDealerId,
            "oemId": m_strOemId,
            "email": m_strEmail,
            //"notes": self.m_strNotes,
            "roles": self.m_arrRoles,
            "username": self.m_strUsername
            ]
        print(params)
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.PUT, strUrl, parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("Register error: \(error)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
            }
            .responseString { (response) in
                print(response.response)
            }

    }

    func requestRegisterToGatewayWithCallback(callback: (status: REG_ERROR_CODE)->Void)
    {
        let strUrl = REGISTER_ENTRY_URL
        print("API URL : " + strUrl)

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.GET, strUrl, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    
                    if let error = json["error"].bool {
                        if error {
                            let errorMsg = json["errorMessage"].stringValue;
                            if errorMsg == "Spa already registered to User" {
                                callback(status: REG_ERROR_CODE.ERROR_ALREADY_REGISTERED)
                            } else {
                                callback(status: REG_ERROR_CODE.ERROR_NOT_REGISTERED)
                            }
                            
                            //Spa not registered to cloud or spa already registered to user.
                        } else {
                            
                            //regKey, spaId, serialNumber
                            BWGSpaManager.sharedInstance.m_ID = json["spaId"].stringValue;
                            BWGSpaManager.sharedInstance.m_RegKey = json["regKey"].stringValue;
                            BWGSpaManager.sharedInstance.m_SerialNumber = json["serialNumber"].stringValue;
                            callback(status: REG_ERROR_CODE.SUCCESS)
                        }
                        
                    } else {
                        callback(status: REG_ERROR_CODE.ERROR_CONNECTION_FAILED)
                    }
                    
                case .Failure(let error):
                    print("Register error: \(error)")
                    callback(status: REG_ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
            }
            //.responseString { (response) in
                //print(response.response)
            //}
    }
    func requestRegisterWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForRegister()
        print("API URL : " + strUrl)
        let params = [
            "spaId": BWGSpaManager.sharedInstance.m_ID,
            "regKey": BWGSpaManager.sharedInstance.m_RegKey,
            "user": [
                "username": m_strUsername,
                "password": m_strPassword,
                "firstname": m_strFirstName,
                "lastname": m_strLastName,
                "phone": m_strPhone,
                "email": m_strEmail,
                "address": [
                    "address1": m_strAddress1,
                    "address2": m_strAddress2,
                    "city": m_strCity,
                    "zipcode": m_strZipcode,
                    "state": m_strState,
                    "country": m_strCountry
                ]
            ]
            
        ]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.POST, strUrl, parameters: (params as! [String : AnyObject]), encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        //Get active gluu access_token.
                        BWGTokenManager.sharedInstance.accessToken = json["access_token"].stringValue
                        BWGTokenManager.sharedInstance.refreshToken = json["refresh_token"].stringValue
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("Register error: \(error)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
            }
            .responseString { (response) in
                print(response.response)
        }
    }
    func requestRegisterExistingUserWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForRegister()
        print("API URL : " + strUrl)
        let params = [
            "spaId": BWGSpaManager.sharedInstance.m_ID,
            "regKey": BWGSpaManager.sharedInstance.m_RegKey,
        ]
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.POST, strUrl, parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("Register error: \(error)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
            }
            .responseString { (response) in
                print(response.response)
        }
    }

    func requestUnregisterWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForUnregister()
        print("Unregister API URL : " + strUrl)
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        manager.request(.DELETE, strUrl, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("Unregister error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
        }

    }
    
    func requestFindCurrentUserAgreement(callback: (status: TAC_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForFindCurrentUserAgreement(m_strId)
        print("API URL : " + strUrl)
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        manager.request(.GET, strUrl, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    //print(json)
                    print("DateAgreed: \(json["dateAgreed"])")
                    callback(status: TAC_CODE.AGREED)
                case .Failure(let error):
                    print("FindCurrentUserAgreement error: \(error)")
                    callback(status: TAC_CODE.ERROR)
                }
        }
        
    }
    func requestWhoAmI(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForWhoAmI()
        print("API URL : " + strUrl)
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        manager.request(.GET, strUrl, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    //print(json)
                    print("Success: WhoAmI ")
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        self.m_strId = json["_id"].stringValue
                        self.m_strEmail = json["email"].stringValue
                        
                        self.m_strUsername = json["username"].stringValue
                        self.m_strFirstName = json["firstName"].stringValue
                        self.m_strLastName = json["lastName"].stringValue
                        self.m_strPhone = json["phone"].stringValue
                        self.m_strAddress1 = json["address"]["address1"].stringValue
                        self.m_strAddress2 = json["address"]["address2"].stringValue
                        self.m_strCity = json["address"]["city"].stringValue
                        self.m_strState = json["address"]["state"].stringValue
                        self.m_strZipcode = json["address"]["zip"].stringValue
                        self.m_strCountry = json["address"]["country"].stringValue
                        
                        self.m_strDealerId = json["dealerId"].stringValue
                        self.m_strOemId = json["oemId"].stringValue
                        
                        self.m_arrRoles.removeAll()
                        let roles = json["roles"].arrayValue
                        for role in roles {
                            self.m_arrRoles.append(role.stringValue)
                        }
                        
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("WhoAmI error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                }
        }
        
    }
}
