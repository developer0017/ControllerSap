//
//  MySpaSettingModel.swift
//  OwnerApp
//
//  Created by Star Developer on 5/26/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class MySpaSettingModel: NSObject {

    var strId: String = ""
    var strName: String = ""
    var strNotes: String = ""
    var creationDate: NSDate
    var temperature: Int = 50
    
    //Scheduling data
    var strStartDate = ""
    var strEndDate = ""
    var strMode: String = "None" //None, Daily, Weekly, Monthly
    var strCronExpression: String = ""
    var strTimeZone: String = ""
    var durationMinutes: Int = 30
    var bEnabled = false
    
    var arrComponents = [SpaComponentModel]()
    override init() {
        creationDate = NSDate()
        strTimeZone = NSTimeZone.localTimeZone().name
        super.init()
    }
}
