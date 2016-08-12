//
//  BWGSpaManager.swift
//  OwnerApp
//
//  Created by Adam on 4/5/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGSpaManager: NSObject {
    static let sharedInstance = BWGSpaManager()
    var m_ID:String = ""
    var m_SerialNumber:String = ""
    var m_RegKey: String = ""
    
    var m_ProductName:String = ""
    var m_ProductModel: String = ""
    var m_OwnerName: String = ""
    
    var m_bSold: Bool = true
    
    var m_DealerId: String = ""
    var m_OemId:String = ""
    var m_ManufacturedDate:String = ""
    var m_RegistrationDate: String = ""
    var m_P2P_AP_SSID: String = ""
    var m_SalesAssociate: String = ""
    var m_TransactionID: String = ""
    
    var m_RunMode: String = ""
    var m_CurrentTemp: Int = 0
    var m_TargetDesiredTemp: Int = 0
    var m_DesiredTemp: Int = 0
    
    var m_components = [JSON]()
    
    //Spa registration flag
    var m_bRegistered: Bool = true
    
    //Spa location
    var m_Lat: Double = 0.0
    var m_Lon: Double = 0.0
    var m_Location: String = ""
    
    //Spa Settings
    var arrMySpaSettings = [MySpaSettingModel]()
    
    var manager: Manager
    
    override init() {
        //Trust policy for self-signed Certificate
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        manager = Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        super.init()
    }
    func initializeManager() {
        m_ID = ""
        m_SerialNumber = ""
        m_RegKey = ""
        
        m_ProductName = ""
        m_ProductModel = ""
        m_OwnerName = ""
        
        m_RunMode = ""
        m_CurrentTemp = 0
        m_TargetDesiredTemp = 0
        m_DesiredTemp = 0
        
        m_Lat = 0.0
        m_Lon = 0.0
        m_Location = ""
        
        m_components.removeAll()
        arrMySpaSettings.removeAll()
    }
    // MARK: - REST API
    func requestFindByUsername(username: String, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaFindByUsername(username)
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
                    let location = json["location"].arrayValue
                    if location.count != 0 {
                        self.m_Lon = location[0].doubleValue
                        self.m_Lat = location[1].doubleValue
                    }
                    
                    self.m_ProductName = json["productName"].stringValue
                    self.m_ProductModel = json["model"].stringValue
                    self.m_OwnerName = json["owner"]["fullName"].stringValue
                    self.m_SerialNumber = json["serialNumber"].stringValue
                    
                    self.m_RegistrationDate = json["registrationDate"].stringValue
                    self.m_ManufacturedDate = json["manufacturedDate"].stringValue
                    self.m_P2P_AP_SSID = json["p2pAPSSID"].stringValue
                    self.m_SalesAssociate = json["associate"]["fullName"].stringValue
                    self.m_TransactionID = json["transactionCode"].stringValue
                    
                    self.m_ID = json["_id"].stringValue
                    self.m_RunMode = json["currentState"]["runMode"].stringValue
                    self.m_CurrentTemp = json["currentState"]["currentTemp"].intValue
                    self.m_TargetDesiredTemp = json["currentState"]["targetDesiredTemp"].intValue
                    self.m_DesiredTemp = json["currentState"]["desiredTemp"].intValue
                    
                    self.m_components.removeAll()
                    let componentsState = json["currentState"]["components"].arrayValue
                    for component in componentsState {
                        if component["availableValues"].count != 0{
                            //If registeredTimestamp exists, display. issue #1
                            if component["registeredTimestamp"].string != nil {
                                //print(component)
                                var temp = component
                                if temp["componentType"].string == "PUMP" {
                                    temp["sortOrder"] = 1
                                } else if temp["componentType"].string == "LIGHT" {
                                    temp["sortOrder"] = 2
                                } else {
                                    temp["sortOrder"] = 3
                                }
                                //print(temp)
                                self.m_components.append(temp)
                            }
                        } 

                    }
                    //m_components sort by type
                    self.m_components.sortInPlace({ $0["sortOrder"] < $1["sortOrder"] })
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("FindByUsername error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
                
        }
            .responseString { (response) in
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print("Error code \(statusCode)")
                } else { //no errors
                    //let statusCode = (response.response?.statusCode)
                    //print("Response code \(statusCode)")
                }
        }
        
    }

    func requestSaveSpaDetails(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaDetails(m_ID)
        print("API URL : " + strUrl)
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let params  = [
            "location": [m_Lon, m_Lat]
            ]
        manager.request(.PATCH, strUrl, parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("SaveSpaDetails error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
                
            }
    }
    func requestSaveSpaSettings(setting: MySpaSettingModel, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaSettings(m_ID)
        print("API URL : " + strUrl)
        
        var paramSettings = [String: AnyObject]()
        for component in setting.arrComponents {
            //Filter process
            if component.componentType == "FILTER"
            {
                var interval = "0" //OFF
                if component.value == .ON {
                    interval = "2" //30 minutes
                }
                let temp = [
                    "intervalNumber" : interval,
                    "deviceNumber" : String(component.deviceNumber)
                ]
                let key = "FILTER_" + String(component.deviceNumber)
                paramSettings[key] = temp
                continue
            }
            let temp = [
                "desiredState": component.value.rawValue,
                "deviceNumber": String(component.deviceNumber),
                "name": component.name
            ]
            let key = component.componentType + "_" + String(component.deviceNumber)
            paramSettings[key] = temp
        }
        
        paramSettings["HEATER"] = [
            "desiredTemp": setting.temperature
        ]
        let params  = [
            "name": setting.strName,
            "notes": "This is a preset.",
            "settings": paramSettings
            ] as [String : AnyObject]
        //print(params)
        
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
                    //print(json)
                    if let error = json["error"].string {
                        print("SaveSpaSetting error: \(error)")
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        let recipeId = json["_id"].stringValue
                        setting.strId = recipeId
                        self.arrMySpaSettings.append(setting)
                        
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                    
                case .Failure(let error):
                    print("SaveSpaSettings error: \(error)")
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 409 {
                            // handle 409 specific error here, which means Recipes reached maximum.
                            callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                        }
                    } else {
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    }
                }
        }
    }
    func requestGetSpaSettings(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaSettings(m_ID)
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
                    self.arrMySpaSettings.removeAll()
                    let recipes = json["_embedded"]["recipeDToes"].arrayValue
                    for recipe in recipes {
                        let temp = MySpaSettingModel()
                        temp.strId = recipe["_id"].stringValue
                        temp.strName = recipe["name"].stringValue
                        temp.strNotes = recipe["notes"].stringValue
                        
                        //Parsing Settings
                        let components = recipe["settings"].dictionaryValue
                        for (type, values) in components {
                            if values.count == 0 { //Blank data
                                continue
                            }
                            let typeArr = type.componentsSeparatedByString("_")
                            let ctemp = SpaComponentModel()
                            if typeArr[0] == "FILTER" {
                                if values["intervalNumber"].intValue == 0 {
                                    ctemp.value = ControlState(rawValue: "OFF")!
                                    
                                } else {
                                    ctemp.value = ControlState(rawValue: "ON")!
                                }
                            } else if typeArr[0] == "HEATER" {
                                temp.temperature = values["desiredTemp"].intValue
                                continue
                            } else {
                                ctemp.value = ControlState(rawValue: values["desiredState"].stringValue)!
                               
                            }
                            ctemp.deviceNumber = values["deviceNumber"].intValue
                            ctemp.componentType = typeArr[0]
                            
                            //Search and Set component name and availableValues.
                            for component in self.m_components {
                                if component["componentType"].stringValue == typeArr[0] {
                                    if component["port"].intValue == ctemp.deviceNumber {
                                        ctemp.name = component["name"].stringValue
                                        let availableValues = component["availableValues"].arrayValue
                                        for val in availableValues {
                                            ctemp.availableValues.append(val.stringValue)
                                        }
                                        break
                                    }
                                }
                            }
                            temp.arrComponents.append(ctemp)
                        }
                        
                        //Parsing Scheduling
                        let schedule = recipe["schedule"]
                        //print(schedule)
                        temp.strCronExpression = schedule["cronExpression"].stringValue
                        temp.bEnabled = schedule["enabled"].boolValue
                        temp.strTimeZone = schedule["timeZone"].stringValue
                        temp.strStartDate = schedule["startDate"].stringValue
                        temp.strEndDate = schedule["endDate"].stringValue
                        temp.durationMinutes = schedule["durationMinutes"].intValue
                        self.arrMySpaSettings.append(temp)
                    }

                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                case .Failure(let error):
                    print("GetSpaSettings error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
            }
            .responseString { (response) in
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print("Error code \(statusCode)")
                }
        }

    }
//    func requestGetSpaRecipe(recipeId: String, callback: (status: ERROR_CODE)->Void)
//    {
//        let strUrl = BWGUrlManager.getEndpointForSpaRecipe(self.m_ID, id: recipeId)
//        print("API URL : " + strUrl)
//        
//        let headers = [
//            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
//        manager.request(.GET, strUrl, headers: headers)
//            .responseJSON { response in
//                switch response.result{
//                case .Success(let data):
//                    let json = JSON(data)
//                    print(json)
//                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
//                case .Failure(let error):
//                    print("GetSpaSettings error: \(error)")
//                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
//                }
//            }
//            .responseString { (response) in
//                if let httpError = response.result.error {
//                    let statusCode = httpError.code
//                    print("Error code \(statusCode)")
//                }
//            }
//
//    }

    func requestUpdateSpaRecipe(index: Int, callback: (status: ERROR_CODE)->Void)
    {
        let setting = self.arrMySpaSettings[index]
        let strUrl = BWGUrlManager.getEndpointForSpaRecipe(self.m_ID, id: setting.strId)
        print("API URL : " + strUrl)
        
        
        var paramSettings = [String: AnyObject]()
        for component in setting.arrComponents {
            //Filter process
            if component.componentType == "FILTER"
            {
                var interval = "0" //OFF
                if component.value == .ON {
                    interval = "2" //30 minutes
                }
                let temp = [
                    "intervalNumber" : interval,
                    "deviceNumber" : String(component.deviceNumber)
                ]
                let key = "FILTER_" + String(component.deviceNumber)
                paramSettings[key] = temp
                continue
            }
            let temp = [
                "desiredState": component.value.rawValue,
                "deviceNumber": String(component.deviceNumber)
            ]
            let key = component.componentType + "_" + String(component.deviceNumber)
            paramSettings[key] = temp
        }
        
        paramSettings["HEATER"] = [
            "desiredTemp": setting.temperature
        ]

        let schedule = [
            "cronExpression": setting.strCronExpression,
            "durationMinutes": setting.durationMinutes,
            "startDate": setting.strStartDate,
            "endDate": setting.strEndDate,
            "timeZone": setting.strTimeZone,
            "enabled": String(setting.bEnabled)
        ]
        print(schedule)
        
        let params  = [
            "_id": setting.strId,
            "name": setting.strName,
            "spaId": self.m_ID,
            "notes": "This is a preset.",
            "settings": paramSettings,
            "schedule": schedule
            ] as [String : AnyObject]

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
                    if let error = json["error"].string {
                        print(error)
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    } else {
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                case .Failure(let error):
                    print("RunSpaRecipe error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
        }
    }
    func requestRunSpaRecipe(recipeId: String, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForRunSpaRecipe(self.m_ID, id: recipeId)
        print("API URL : " + strUrl)

        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.POST, strUrl, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("RunSpaRecipe error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
                
        }
        .responseString { (response) in
            print(response)
        }
    }
    func requestDeleteSpaRecipe(recipeId: String, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaRecipe(self.m_ID, id: recipeId)
        print("API URL : " + strUrl)
        
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.DELETE, strUrl, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    if let error = json["error"].string {
                        print("DeleteSpaRecipe error: \(error)")
                        callback(status: ERROR_CODE.ERROR_INVALID_PARAMETER)
                    }
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("DeleteSpaRecipe error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
        }
//            .responseString { (response) in
//                print(response)
//        }
    }
    
    func requestControlSetDesiredTemp(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaSetDesiredTemp(m_ID)
        print("API URL : " + strUrl)
        let params = [
            "desiredTemp": String(m_TargetDesiredTemp),
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
                    self.m_DesiredTemp = json["values"]["DESIREDTEMP"].intValue
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("SetDesiredTemp error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
        }
    }

    func requestSetFilterCycleIntervals(index: Int, callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = BWGUrlManager.getEndpointForSpaSetFilterCycleIntervals(m_ID)
        print("API URL : " + strUrl)
        var interval: String
        if m_components[index]["desiredState"].stringValue == "ON" {
            interval = "2" //30 minutes
        } else {
            interval = "0" //OFF
        }
        let params = [
            "intervalNumber": interval,
            "deviceNumber": m_components[index]["port"].stringValue,
            "originatorId": "optional-filtercycle"
        ]
        self._requestCommon(strUrl, params: params, callback: callback)
    }
    
    func requestSetControlState(index: Int, callback: (status: ERROR_CODE)->Void)
    {
        var strType: String
        let componentType = m_components[index]["componentType"].stringValue
        switch componentType {
        case "PUMP":
            strType = "Jet"
            break
        case "BLOWER":
            strType = "Blower"
            break
        case "LIGHT":
            strType = "Light"
            break
        case "MISTER":
            strType = "Mister"
            break
        case "AUX":
            strType = "Aux"
            break
        case "MICROSILK":
            strType = "Microsilk"
            break
        case "CIRCULATION_PUMP":
            strType = "CircPump"
            break
        default:
            return
        }
        let strUrl = BWGUrlManager.getEndpointForSpaSetControlState(m_ID, componentType: strType)
        print("API URL : " + strUrl)
        let params = [
            "deviceNumber": m_components[index]["port"].stringValue,
            "desiredState": m_components[index]["desiredState"].stringValue,
            "originatorId": "optional-" + strType
        ]
        //print(params)
        self._requestCommon(strUrl, params: params, callback: callback)
    }
    internal func _requestCommon(url: String, params: [String: AnyObject], callback: (status: ERROR_CODE)->Void)
    {
        let headers = [
            "Authorization": "Bearer \(BWGTokenManager.sharedInstance.accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        manager.request(.POST, url, parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                }
                
            }
    }
}
