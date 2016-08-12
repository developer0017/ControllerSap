//
//  ContainerVC.swift
//  OwnerApp
//
//  Created by Adam on 5/9/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class ContainerVC: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        SlideMenuOptions.contentViewScale = 1.0
        let tempVC = self.storyboard?.instantiateViewControllerWithIdentifier("TempVC") as! TempVC
        self.mainViewController = tempVC
        
        let leftVC = self.storyboard?.instantiateViewControllerWithIdentifier("LeftVC") as! LeftVC
        leftVC.tempVC = tempVC
        self.leftViewController = leftVC
        
        super.awakeFromNib()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
