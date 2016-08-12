//
//  SpaControlCVCell3.swift
//  OwnerApp
//
//  Created by Star Developer on 6/27/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaControlCVCell3: SpaControlCVBaseCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnOff: UIButton!
    @IBOutlet weak var btnLow: UIButton!
    @IBOutlet weak var btnHi: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackground.layer.cornerRadius = 8.0
        self.viewBackground.clipsToBounds = true
        
        //For iPhone5s, iPhone5
        btnOff.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnLow.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnHi.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    @IBAction func onClick(sender: AnyObject) {
        if name == "CIRCULATION_PUMP" {
            print("read-only")
            return
        }
        self.lastUserActionTimestamp = NSDate()
        if sender.tag == 101 {
            self.desiredState = .OFF
        } else if sender.tag == 102 {
            self.desiredState = .LOW
        } else if sender.tag == 104 {
            self.desiredState = .HIGH
        }
        self.value = self.desiredState
        self.refreshControlState()
        //Call to Rest API
        self.delegate!.setControlState(self)
    }
    
    //MARK: - Refresh UI
    func refreshControlState() {
        btnOff.selected = false
        btnLow.selected = false
        btnHi.selected = false
        lblState.text = self.value.rawValue
        
        switch self.value {
        case .OFF:
            btnOff.selected = true
            viewBackground.backgroundColor = UIColor.whiteColor()
            break
        case .LOW:
            btnLow.selected = true
            viewBackground.backgroundColor = bgColor
            break
        case .HIGH:
            btnHi.selected = true
            viewBackground.backgroundColor = bgColor
            break
        case .HI:
            btnHi.selected = true
            viewBackground.backgroundColor = bgColor
            break
        default:
            btnOff.selected = true
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
