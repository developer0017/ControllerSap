//
//  HeaderView.swift
//  OwnerApp
//
//  Created by Adam on 3/31/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate{
    func onClickSetting()
}
class HeaderView: UIView {
    
    var delegate:HeaderViewDelegate?

    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnAlert1: UIButton!
    @IBOutlet weak var btnAlert2: UIButton!
    @IBOutlet weak var btnClock: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    
    override func awakeFromNib() {
        btnAlert1.hidden = true
        btnAlert2.hidden = true
    }
    
    
    //MARK - Click
    @IBAction func onClickSetting(sender: UIButton) {
        self.delegate?.onClickSetting()
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
