//
//  BaseVC.swift
//  OwnerApp
//
//  Created by Adam on 3/31/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    let spaManager = BWGSpaManager.sharedInstance
    let weatherManager = BWGWeatherManager.sharedInstance
    
    var viewFooter: FooterView!
    var viewHeader: HeaderView!
    var imgBackground: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgBackground = UIImageView(frame: UIScreen.mainScreen().bounds)
        imgBackground.image = UIImage(named: "DayBG")
        imgBackground.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.view.insertSubview(imgBackground, atIndex: 0)
        
        //Hide keyboard by touching anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(_dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Internal Methods
    internal func actionNavigateTo(viewController: UIViewController) {
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
    
    internal func _showSessionExpiredAlert() {
        let alertController = UIAlertController(title: nil, message: "Your session has expired.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginVC") as UIViewController
            self.actionNavigateTo(loginVC)
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func _showAlert(msg: String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func _showAlertWithAction(strTitle: String, strMsg: String, action: UIAlertAction) {
        let alertController = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .Alert)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func _changeBackground() {
        if self.weatherManager.lat == 0 || self.weatherManager.lon == 0 {
            return
        }
        switch self.weatherManager.weather_icon {
        case "01d",
             "02d",
             "03d",
             "04d",
             "09d",
             "10d",
             "11d",
             "13d",
             "50d":
            self.imgBackground.image = UIImage(named: "DayBG")
            break
        case "01n",
             "02n",
             "03n",
             "04n",
             "09n",
             "10n",
             "11n",
             "13n",
             "50n":
            self.imgBackground.image = UIImage(named: "NightBG")
            break
        default:
            break
            
        }
        
    }
    internal func _dismissKeyboard() {
        view.endEditing(true)
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
