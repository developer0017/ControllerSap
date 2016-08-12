//
//  AccountVC.swift
//  OwnerApp
//
//  Created by Adam on 4/1/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class AccountVC: BaseVC {
    let userManager = BWGUserManager.sharedInstance
    
    @IBOutlet weak var btnUpdateAccount: UIButton!
    @IBOutlet weak var btnUnregister: UIButton!
    
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtPrimaryEmail: UITextField!
    @IBOutlet weak var txtPrimaryPhone: UITextField!

    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewAddress1: UIView!
    @IBOutlet weak var viewAddress2: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewZipcode: UIView!
    @IBOutlet weak var viewCountry: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imgBackground.image = UIImage(named: "LaunchBackground")
        self.initUI()
    }

    override func viewDidAppear(animated: Bool) {
        self.getAccountInfo()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Click Event
    @IBAction func onClickUpdate(sender: AnyObject) {
        if !Utility.isValidEmail(txtPrimaryEmail.text!) {
            self._showAlert("Please enter valid email address.")
            return
        }
        self.userManager.m_strFirstName = txtFirstname.text!
        self.userManager.m_strLastName = txtLastname.text!
        self.userManager.m_strEmail = txtPrimaryEmail.text!
        self.userManager.m_strPhone = txtPrimaryPhone.text!
        self.userManager.m_strAddress1 = txtAddress1.text!
        self.userManager.m_strAddress2 = txtAddress2.text!
        self.userManager.m_strCity = txtCity.text!
        self.userManager.m_strState = txtState.text!
        self.userManager.m_strZipcode = txtZipcode.text!
        self.userManager.m_strCountry = txtCountry.text!        
        
        Utility.showMessage(self.view, text: "Update in progress...")
        self.userManager.requestUpdateAccountWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self._showAlert("Update Success")
                break
            case .ERROR_INVALID_PARAMETER:
                self._showAlert("Update Failed")
                break
            default:
                self._showAlert("Connection Failed")
                break
            }
        })
    }
    
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    @IBAction func onClickUnregister(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Are you sure to unregister spa to this user?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default){(action) in
            self._unregister()
        }
        let noAction = UIAlertAction(title: "No", style: .Default){(action) in
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Internal function
    internal func _unregister() {
        Utility.showMessage(self.view, text: "Please wait...")
        userManager.requestUnregisterWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                //Unregister successful.
                BWGUserManager.sharedInstance.removeUserLoginFromLocalStorage()
                BWGSpaManager.sharedInstance.m_bRegistered = false
                self.navigationController?.popToRootViewControllerAnimated(true)
                break
            default:
                break
            }
        })
    }
    internal func initUI() {
        let cornerRadius: CGFloat = 8.0
        btnUpdateAccount.layer.cornerRadius = cornerRadius
        btnUpdateAccount.layer.borderWidth = 1.0
        btnUpdateAccount.layer.borderColor = UIColor.whiteColor().CGColor
        btnUpdateAccount.layer.masksToBounds = true
        
        btnUnregister.layer.cornerRadius = cornerRadius
        btnUnregister.layer.borderWidth = 1.0
        btnUnregister.layer.borderColor = UIColor.whiteColor().CGColor
        btnUnregister.layer.masksToBounds = true
        
        viewFirstName.layer.cornerRadius = 5.0
        viewFirstName.layer.masksToBounds = true
        viewFirstName.layer.backgroundColor = bgColor.CGColor
        
        viewLastName.layer.cornerRadius = 5.0
        viewLastName.layer.masksToBounds = true
        viewLastName.layer.backgroundColor = bgColor.CGColor
        
        viewEmail.layer.cornerRadius = 5.0
        viewEmail.layer.masksToBounds = true
        viewEmail.layer.backgroundColor = bgColor.CGColor
        
        viewPhoneNumber.layer.cornerRadius = 5.0
        viewPhoneNumber.layer.masksToBounds = true
        viewPhoneNumber.layer.backgroundColor = bgColor.CGColor
        
        viewAddress1.layer.cornerRadius = 5.0
        viewAddress1.layer.masksToBounds = true
        viewAddress1.layer.backgroundColor = bgColor.CGColor
        
        viewAddress2.layer.cornerRadius = 5.0
        viewAddress2.layer.masksToBounds = true
        viewAddress2.layer.backgroundColor = bgColor.CGColor
        
        viewCity.layer.cornerRadius = 5.0
        viewCity.layer.masksToBounds = true
        viewCity.layer.backgroundColor = bgColor.CGColor
        
        viewState.layer.cornerRadius = 5.0
        viewState.layer.masksToBounds = true
        viewState.layer.backgroundColor = bgColor.CGColor
        
        viewZipcode.layer.cornerRadius = 5.0
        viewZipcode.layer.masksToBounds = true
        viewZipcode.layer.backgroundColor = bgColor.CGColor
        
        viewCountry.layer.cornerRadius = 5.0
        viewCountry.layer.masksToBounds = true
        viewCountry.layer.backgroundColor = bgColor.CGColor
        
    }

    internal func getAccountInfo() {
        self.txtFirstname.text = userManager.m_strFirstName
        self.txtLastname.text = userManager.m_strLastName
        self.txtPrimaryEmail.text = userManager.m_strEmail
        self.txtPrimaryPhone.text = userManager.m_strPhone
        self.txtAddress1.text = userManager.m_strAddress1
        self.txtAddress2.text = userManager.m_strAddress2
        self.txtCity.text = userManager.m_strCity
        self.txtState.text = userManager.m_strState
        self.txtZipcode.text = userManager.m_strZipcode
        self.txtCountry.text = userManager.m_strCountry
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
