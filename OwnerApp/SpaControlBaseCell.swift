//
//  SpaControlBaseCell.swift
//  OwnerApp
//
//  Created by Adam on 4/8/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

protocol SpaControlCellDelegate {
    func callSetControlState(cell: SpaControlBaseCell)
}
class SpaControlBaseCell: UITableViewCell {
    let MARGINBUBBLE:CGFloat = 15.0
    let LOCKTIME:NSTimeInterval = 20.0
    
    var deviceNumber: Int = 0
    var desiredState: ControlState = .OFF
    var value: ControlState = .OFF
    var name: String = ""
    var componentType: String = ""
    var availableValues = [String]()
    var lastUserActionTimestamp: NSDate!
    
    var delegate: SpaControlCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
}
