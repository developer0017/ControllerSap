//
//  SpaControlCVBaseCell.swift
//  OwnerApp
//
//  Created by Star Developer on 6/21/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
protocol SpaControlCVCellDelegate {
    func setControlState(cell: SpaControlCVBaseCell)
    func showAlert(msg: String)
}
class SpaControlCVBaseCell: UICollectionViewCell {
    let LOCKTIME:NSTimeInterval = 20.0
    
    var deviceNumber: Int = 0
    var desiredState: ControlState = .OFF
    var value: ControlState = .OFF
    var name: String = ""
    var componentType: String = ""
    var availableValues = [String]()
    var lastUserActionTimestamp: NSDate!
    
    var delegate: SpaControlCVCellDelegate?
}
