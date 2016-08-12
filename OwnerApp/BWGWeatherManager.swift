//
//  BWGWeatherManager.swift
//  OwnerApp
//
//  Created by Star Developer on 5/12/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BWGWeatherManager: NSObject {
    static let sharedInstance = BWGWeatherManager()
    var lon: Double
    var lat: Double
    var weather_main: String
    var weather_description: String
    var weather_icon: String
    var temp: Float
    var pressure: Float
    var humidity: Float
    var wind_speed: Float
    var wind_deg: Float
    var name: String
    
    override init() {
        lon = 0
        lat = 0
        weather_main = ""
        weather_description = ""
        weather_icon = ""
        temp = 0
        pressure = 0
        humidity = 0
        wind_speed = 0
        wind_deg = 0
        name = ""
    }
    func requestWeatherWithCallback(callback: (status: ERROR_CODE)->Void)
    {
        let strUrl = WEATHER_URL + "/weather"
        print("API URL : " + strUrl)
        
        let params = [
            "APPID": WEATHER_API_KEY,
            "lat": String(lat),
            "lon": String(lon),
        ]
        print(params)
        Alamofire.request(.GET, strUrl, parameters: params)
            .responseJSON { response in
                switch response.result{
                case .Success(let data):
                    let json = JSON(data)
                    //print(json)
                    if json["cod"].intValue == 404 {
                        callback(status: ERROR_CODE.ERROR_INVALID_REQUEST)
                    } else {
                        let weather = json["weather"].arrayValue
                        self.weather_main = weather[0]["main"].stringValue
                        self.weather_description = weather[0]["description"].stringValue
                        self.weather_icon = weather[0]["icon"].stringValue
                        self.temp = json["main"]["temp"].floatValue
                        self.pressure = json["main"]["pressure"].floatValue
                        self.humidity = json["main"]["humidity"].floatValue
                        self.wind_speed = json["wind"]["speed"].floatValue
                        self.wind_deg = json["wind"]["deg"].floatValue
                        self.name = json["name"].stringValue
                        callback(status: ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                    }
                case .Failure(let error):
                    print("Error: \(error)")
                    callback(status: ERROR_CODE.ERROR_CONNECTION_FAILED)
                }
        }
    }

}
