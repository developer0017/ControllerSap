//
//  TermsAndConditionsVC.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    let tacManager = BWGTACManager.sharedInstance

    @IBOutlet weak var txtTAC: UITextView!
    @IBOutlet weak var btnAgree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnAgree.layer.cornerRadius = 8.0
        btnAgree.layer.borderWidth = 1.0
        btnAgree.layer.borderColor = UIColor.whiteColor().CGColor
        btnAgree.layer.masksToBounds = true
        
        getMostRecentTAC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMostRecentTAC() {
        Utility.showMessage(self.view, text: "Loading...")
        tacManager.requestFindMostRecentTAC({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.txtTAC.text = self.tacManager.m_strText
                break
            default:
                self.txtTAC.text = "Can't get the Terms and Conditions."
                break
            }
        })
    }
    // MARK: - Click Event
    @IBAction func onClickAgree(sender: UIButton) {
        Utility.showMessage(self.view, text: "Please wait...")
        tacManager.requestAgreeTAC(BWGUserManager.sharedInstance.m_strId, callback: { (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.performSegueWithIdentifier("segueToTemp", sender: self)
                break
            default:
                self._showAlert("Please try again later.")
            }
        })
    }

    // MARK: - Internal methods
    private func _showAlert(msg: String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
