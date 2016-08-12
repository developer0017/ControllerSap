//
//  SpaControlCVCell4.swift
//  OwnerApp
//
//  Created by Star Developer on 6/21/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaControlCVCell4: SpaControlCVBaseCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnOff: UIButton!
    @IBOutlet weak var btnLow: UIButton!
    @IBOutlet weak var btnMed: UIButton!
    @IBOutlet weak var btnHi: UIButton!

    @IBOutlet weak var viewBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //For iPhone5s, iPhone5
        btnOff.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnLow.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnMed.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnHi.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.viewBackground.layer.cornerRadius = 8.0
        self.viewBackground.clipsToBounds = true
    }
    
    @IBAction func onClick(sender: AnyObject) {
        self.lastUserActionTimestamp = NSDate()
        if sender.tag == 101 {
            self.desiredState = .OFF
        } else if sender.tag == 102 {
            self.desiredState = .LOW
        } else if sender.tag == 103 {
            self.desiredState = .MED
        } else if sender.tag == 104 {
            self.desiredState = .HIGH
        }
        self.value = self.desiredState
        self.refreshControlState()
        //Call to Rest API
        self.delegate!.setControlState(self)
    }

    func refreshControlState() {
        btnOff.selected = false
        btnLow.selected = false
        btnMed.selected = false
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
        case .MED:
            btnMed.selected = true
            viewBackground.backgroundColor = bgColor
            break
        case .HIGH, .HI:
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
