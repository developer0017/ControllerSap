//
//  BWGNetworkManager.swift
//  OwnerApp
//
//  Created by Adam on 6/23/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGNetworkManager: NSObject {
    static let sharedInstance = BWGNetworkManager()
    
    var m_SSID: String = ""
    var m_Password: String = ""
    var m_IPAddress: String = ""
    var m_SubnetMask: String = ""
    var m_Gateway: String = ""
    var m_DHCP: Bool = false
    var m_EthernetPluggedIn: Bool = false
    
    var manager: Manager
    override init() {
        //Trust policy for self-signed Certificate
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        manager = Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    func requestGetNetworkSettingsWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = NETWORK_SETTINGS_URL
        print("API URL : " + strUrl)

        manager.request(.GET, strUrl, parameters: nil)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    let wifi = json["wifi"]
                    
                    if wifi != nil {
                       self.m_SSID = wifi["ssid"].stringValue
                        self.m_Password = wifi["password"].stringValue
                    } else {
                        
                    }
                    self.m_EthernetPluggedIn = json["ethernetPluggedIn"].boolValue
                    self.m_IPAddress = json["ethernet"]["ipAddress"].stringValue
                    self.m_SubnetMask = json["ethernet"]["netmask"].stringValue
                    self.m_Gateway = json["ethernet"]["gateway"].stringValue
                    self.m_DHCP = json["ethernet"]["dhcp"].boolValue
                    
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
        }
    }
    func requestPutNetworkSettingsWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = NETWORK_SETTINGS_URL
        print("API URL : " + strUrl)
        
        var params = [
            "ethernet": [
                "ipAddress": m_IPAddress,
                "netmask": m_SubnetMask,
                "gateway": m_Gateway,
                "dhcp": m_DHCP
            ],
            //"ethernetPluggedIn": m_EthernetPluggedIn,
        ] as [String: AnyObject]
        
        if !m_SSID.isEmpty {
            let wifiSetting = [
                    "ssid": m_SSID,
                    "password": m_Password
                ]
            params["wifi"] = wifiSetting
        }
        print(params)
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.POST, strUrl, parameters: params, encoding: .JSON, headers: headers)
//            .responseJSON { response in
//                switch response.result{
//                case .Success(let data):
//                    _ = JSON(data)
//                    //print(json)
//                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
//                case .Failure(let error):
//                    print("Error: \(error)")
//                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
//                }
//                
//        }
            .responseString { (response) in
                print(response.response)
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print("Failure: \(statusCode)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                } else {
                    let statusCode = (response.response?.statusCode)
                    print("Success: \(statusCode)")
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                }
        }
    }
}
