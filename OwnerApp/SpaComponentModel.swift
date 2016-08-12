//
//  SpaComponentModel.swift
//  OwnerApp
//
//  Created by Star Developer on 5/26/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaComponentModel: NSObject {
    
    var name: String = ""
    var deviceNumber: Int = 0
    var componentType: String = ""
    var value: ControlState = .OFF
    //var targetValue: ControlState = .OFF
    var availableValues = [String]()
    
}
