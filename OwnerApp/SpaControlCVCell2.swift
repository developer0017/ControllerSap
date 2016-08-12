//
//  SpaControlCVCell2.swift
//  OwnerApp
//
//  Created by Star Developer on 6/21/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaControlCVCell2: SpaControlCVBaseCell {
    
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var viewBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackground.layer.cornerRadius = 8.0
        self.viewBackground.clipsToBounds = true
    }
    @IBAction func onClickChangeState(sender: AnyObject) {
        if componentType == "CIRCULATION_PUMP" {
            print("read-only")
            self.delegate?.showAlert("Read-only control!")
            return
        }
        self.lastUserActionTimestamp = NSDate()
        switch self.value {
        case .OFF:
            //Process for {"OFF", "HIGH"}
            if self.availableValues.contains("ON") {
                self.desiredState = .ON
            } else {
                self.desiredState = ControlState(rawValue: "HIGH")!
            }
            break
        case .ON, .HIGH:
            self.desiredState = .OFF
            break
        default:
            break
        }
        self.value = self.desiredState
        self.refreshControlState()
        //Call to Rest API
        self.delegate!.setControlState(self)
    }

    func refreshControlState() {
        lblState.text = self.value.rawValue
        switch self.value {
        case .OFF:
            btnState.selected = false
            viewBackground.backgroundColor = UIColor.whiteColor()
            break
        case .ON, .HIGH:
            btnState.selected = true
            viewBackground.backgroundColor = bgColor
            break
        default:
            btnState.selected = false
            viewBackground.backgroundColor = UIColor.whiteColor()
            break
        }
    }
    func initUI() {
        self.lblName.text = name
        if lastUserActionTimestamp != nil {
            let elapsedTime = NSDate().timeIntervalSinceDate(lastUserActionTimestamp)
            if(elapsedTime < LOCKTIME){
                print("\(name) : Elapsed less than 20 seconds")
                return
            }
        }
        self.refreshControlState()
    }
}
