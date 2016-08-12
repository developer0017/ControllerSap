//
//  Constants.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//
import Alamofire
import UIKit

//URLs for QA
let NETWORK_SETTINGS_URL = "http://192.168.78.15:8080/networkSettings"
let REGISTER_ENTRY_URL = "http://192.168.78.15:8080/registerUserToSpa"
let BASE_URL = "https://iotqa.controlmyspa.com/mobile"
let ENTRY_URL = "https://iotqa.controlmyspa.com/idm/tokenEndpoint"

// MARK: - UI Constants
//background color for cell.
let bgColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
let txtColor = UIColor(red: 24/255, green: 71/255, blue: 110/255, alpha: 1.0)

//URLs for DEV
//let REGISTER_ENTRY_URL = "https://192.168.0.58:3333/registerUserToSpa"
//let ENTRY_URL = "https://iotdev02.bi.local:8443/idm/tokenEndpoint"
//let BASE_URL = "https://iotdev02.bi.local:8443/mobile"

// MARK: Weather URL and KEY
let WEATHER_URL = "http://api.openweathermap.org/data/2.5"
let WEATHER_API_KEY = "4a3c5aac25a8f8d2b99a836f9a7bbe93"

let serverTrustPolicies: [String: ServerTrustPolicy] = [
    "iotqa.controlmyspa.com": .DisableEvaluation,
    "idmqa.controlmyspa.com": .DisableEvaluation,
    "iotdev02.bi.local": .DisableEvaluation,
    "192.168.78.15": .DisableEvaluation
]

let BUTTON_BGCOLOR1 = UIColor(red: 177.0/255.0, green: 235.0/255.0, blue: 252.0/255.0, alpha: 1.0)
let BUTTON_BGCOLOR2 = UIColor(red: 217.0/255.0, green: 236.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let COLOR_UNSELECTED = UIColor(red: 177.0/255.0, green: 235.0/255.0, blue: 252.0/255.0, alpha: 1.0)

let REFRESH_TIME_INTERVAL:NSTimeInterval = 5

// MARK: Notification
let NOTIFICATION_LOCATION = "Notification_LocationChanged"

// MARK: Error Code
enum ERROR_CODE {
    case SUCCESS_WITH_NO_ERROR
    case ERROR_CONNECTION_FAILED
    case ERROR_INVALID_PARAMETER
    case ERROR_INVALID_REQUEST
}
// MARK: Registration Error Code
enum REG_ERROR_CODE {
    case SUCCESS
    case ERROR_NOT_REGISTERED
    case ERROR_ALREADY_REGISTERED
    case ERROR_CONNECTION_FAILED
}
// MARK: TAC return code
enum TAC_CODE {
    case AGREED
    case DIDNOT_AGREE
    case ERROR
}
enum ControlState: String {
    case ON = "ON"
    case OFF = "OFF"
    case LOW = "LOW"
    case MED = "MED"
    case HIGH = "HIGH"
    case HI = "HI"
}

// MARK: Local storage keys
let LOCALSTORAGE_USERCREDENTIAL = "USERCREDENTIAL"
