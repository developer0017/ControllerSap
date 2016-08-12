//
//  SpaControlCell2.swift
//  OwnerApp
//
//  Created by Adam on 4/7/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaControlCell2: SpaControlBaseCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var btnOff: UIButton!
    
    @IBOutlet weak var imgSepBubbleLeft: UIImageView!
    @IBOutlet weak var imgSepBubbleRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //For iPhone5s, iPhone5
        btnOff.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnOn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    //MARK: - Click Event
    @IBAction func onClick(sender: UIButton) {
        if name == "CIRCULATION_PUMP" {
            print("read-only")
            return
        }
        self.lastUserActionTimestamp = NSDate()
        if sender.tag == 101 {
            self.desiredState = .OFF
        } else if sender.tag == 102 {
            //Process for {"OFF", "HIGH"}
            if self.availableValues.contains("ON") {
                self.desiredState = .ON
            } else {
                self.desiredState = ControlState(rawValue: "HIGH")!
            }
        }
        self.value = self.desiredState
        self.refreshControlState()
        //Call to Rest API
        self.delegate!.callSetControlState(self)
    }
    //MARK: - Refresh UI
    func refreshControlState() {
        btnOff.selected = false
        btnOn.selected = false
        
        switch self.value {
        case .OFF:
            btnOff.selected = true
            break
        case .ON:
            btnOn.selected = true
            break
        case .HIGH:
            btnOn.selected = true
            break
        default:
            btnOff.selected = true
            break
        }
    }
    func initUI() {
        self.lblTitle.text = name // + String(deviceNumber)
        /*let labelTextWidth = self.lblTitle.intrinsicContentSize().width
        imgSepBubbleLeft.frame = CGRect(origin: CGPointMake((self.frame.size.width-labelTextWidth)/2-imgSepBubbleLeft.frame.width-MARGINBUBBLE, imgSepBubbleLeft.frame.origin.y),
                                        size: imgSepBubbleLeft.frame.size)
        imgSepBubbleRight.frame = CGRect(origin: CGPointMake((self.frame.size.width+labelTextWidth)/2+MARGINBUBBLE, imgSepBubbleLeft.frame.origin.y),
                                         size: imgSepBubbleLeft.frame.size)*/
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
