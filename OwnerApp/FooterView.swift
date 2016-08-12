//
//  FooterView.swift
//  OwnerApp
//
//  Created by Adam on 3/31/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet weak var btnTemp: UIButton!
    @IBOutlet weak var btnControls: UIButton!
    @IBOutlet weak var btnExtras: UIButton!
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblControls: UILabel!
    @IBOutlet weak var lblExtras: UILabel!
    
    //let COLOR_UNSELECTED = UIColor(red: 177.0/255.0, green: 235.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        lblTemp.textColor = COLOR_UNSELECTED
        lblControls.textColor = COLOR_UNSELECTED
        lblExtras.textColor = COLOR_UNSELECTED
        btnTemp.selected = false
        btnControls.selected = false
        btnExtras.selected = false
    }
    // MARK: Button Action
    @IBAction func onClickFooterButton(sender: UIButton) {
        /*lblTemp.textColor = COLOR_UNSELECTED
        lblControls.textColor = COLOR_UNSELECTED
        lblExtras.textColor = COLOR_UNSELECTED
        btnTemp.selected = false
        btnControls.selected = false
        btnExtras.selected = false*/
        if sender.tag == 100 //Temp
        {
            let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TempVC") as UIViewController
            self.actionNavigateTo(tempVC)
            
        } else if sender.tag == 101 //Controls
        {
            let controlsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ControlsVC") as UIViewController
            self.actionNavigateTo(controlsVC)
        } else if sender.tag == 102 //Extras
        {
            let extrasVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ExtrasVC") as UIViewController
            self.actionNavigateTo(extrasVC)
            
        }
    }
    
    func actionNavigateTo(viewController: UIViewController) {
        let navController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UINavigationController
        var index = false
        var nextVC = viewController as UIViewController!
        if !navController.viewControllers[navController.viewControllers.count-1].isKindOfClass(viewController.classForCoder){
            for vc in navController.viewControllers {
                if(vc.isKindOfClass(viewController.classForCoder))
                {
                    index = true
                    nextVC = vc
                }
            }
            if index {
                navController.popToViewController(nextVC, animated: false)
            } else {
                navController.pushViewController(nextVC, animated: false)
            }
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
