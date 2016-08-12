//
//  BWGTACManager.swift
//  OwnerApp
//
//  Created by Adam on 4/3/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGTACManager: NSObject {
    static let sharedInstance = BWGTACManager()
    var m_strText: String
    var m_strVersion: String
    var m_dtCreated: NSDate
    var m_isCurrent: Bool
    var m_dtAgreed: NSDate
    
    var manager: Manager
    
    override init() {
        m_strText = ""
        m_strVersion = ""
        m_dtCreated = NSDate()
        m_dtAgreed = NSDate()
        m_isCurrent = false
        
        //Trust policy for self-signed Certificate
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        manager = Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        super.init()
    }

    func requestFindMostRecentTAC(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForFindMostRecentTAC()
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
                    print(json)
                    self.m_strText = json["text"].stringValue
                    self.m_strVersion = json["version"].stringValue
                    self.m_isCurrent = json["current"].boolValue
                    let strDate = json["createdTimestamp"].stringValue
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    self.m_dtCreated = dateFormatter.dateFromString(strDate)!
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
        }
    }
    func requestAgreeTAC(userId: String, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForAgreeTAC()
        print("API URL : " + strUrl)
        let params = [
            "userId": userId,
            "version": m_strVersion
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
                    let strDate = json["dateAgreed"].stringValue
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    self.m_dtAgreed = dateFormatter.dateFromString(strDate)!
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                }
        }

    }
}
