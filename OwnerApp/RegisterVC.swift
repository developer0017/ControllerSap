//
//  RegisterVC.swift
//  OwnerApp
//
//  Created by Star Developer on 4/19/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import Alamofire

class RegisterVC: UIViewController {
    let userManager = BWGUserManager.sharedInstance

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewZipcode: UIView!
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        
        //Hide keyboard by touching anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(_dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Informs user to press button on IoT gateway module.(triggers the spa system to launch AP mode which enables registration.)
        //Tells user to check their Wifi and connect to a SSID that starts with BWG_SPA_<SERIAL_NUM>.
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            self._registerToGateway()
        }
        self._showAlertWithAction("Please press button on Iot gateway module. Check your wifi and connect to a SSID that starts with BWG_SPA_<SERIAL_NUM>", action: okAction)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Internal functions
    
    
    private func _registerToGateway()
    {
        Utility.showMessage(self.view, text: "Please wait...")
        userManager.requestRegisterToGatewayWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS:
                //Enter existing uid/pwd or create new user and tells the user to switch their wifi back to normal ssid connection.
                let alertController = UIAlertController(title: nil, message: "Please switch your wifi back to normal SSID connection.", preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                    self.navigationController?.popViewControllerAnimated(true)
                }
                alertController.addAction(cancelAction)
                
                let newAction = UIAlertAction(title: "Create New User", style: .Default) { (action) in
                    print("Choose New")
                }
                alertController.addAction(newAction)
                
                let existingAction = UIAlertAction(title: "Existing User", style: .Default) { (action) in
                    print("Choose Existing")
                    BWGSpaManager.sharedInstance.m_bRegistered = false
                    self.navigationController?.popViewControllerAnimated(true)
                }
                alertController.addAction(existingAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
//                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
//                    //Create New or Existing account.
//                }
//                self._showAlertWithAction("Please switch your wifi back to normal SSID connection.", action: okAction)
                break
            case .ERROR_NOT_REGISTERED:
                //User registration to the spa is not allowed until spa system has registered to cloud.
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                }
                self._showAlertWithAction("Spa is not registered to cloud.", action: okAction)
                break
            case .ERROR_ALREADY_REGISTERED:
                //Spa is already registered and Current owner must unregister first.
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                }
                self._showAlertWithAction("Spa is already registered to user.", action: okAction)
                
                break
            default:
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                }
                self._showAlertWithAction("Please check your network connection.", action: okAction)
                break
            }
        })
    }
    private func _register()
    {
        Utility.showMessage(self.view, text: "Register in progress...")
        userManager.requestRegisterWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.performSegueWithIdentifier("segueToTempAfterRegister", sender: self)
                }
                self._showAlertWithAction("Successfully registered.", action: okAction)
                break
            case .ERROR_INVALID_PARAMETER:
                print("Invalid parameter for register")
                break
            default:
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                }
                self._showAlertWithAction("Please check your network connection.", action: okAction)
                break
            }
        })
    }
    private func _showAlertWithAction(msg: String, action: UIAlertAction) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    internal func _dismissKeyboard() {
        view.endEditing(true)
    }
    private func initUI() {
        btnCreateAccount.layer.cornerRadius = 8.0
        btnCreateAccount.layer.borderWidth = 1.0
        btnCreateAccount.layer.borderColor = UIColor.whiteColor().CGColor
        btnCreateAccount.layer.masksToBounds = true
       
        viewFirstName.layer.cornerRadius = 5.0
        viewFirstName.layer.masksToBounds = true
        viewFirstName.layer.backgroundColor = bgColor.CGColor
        
        viewLastName.layer.cornerRadius = 5.0
        viewLastName.layer.masksToBounds = true
        viewLastName.layer.backgroundColor = bgColor.CGColor
        
        viewEmail.layer.cornerRadius = 5.0
        viewEmail.layer.masksToBounds = true
        viewEmail.layer.backgroundColor = bgColor.CGColor
        
        viewPassword.layer.cornerRadius = 5.0
        viewPassword.layer.masksToBounds = true
        viewPassword.layer.backgroundColor = bgColor.CGColor
        
        viewPhoneNumber.layer.cornerRadius = 5.0
        viewPhoneNumber.layer.masksToBounds = true
        viewPhoneNumber.layer.backgroundColor = bgColor.CGColor
        
        viewAddress.layer.cornerRadius = 5.0
        viewAddress.layer.masksToBounds = true
        viewAddress.layer.backgroundColor = bgColor.CGColor
        
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
    // MARK: - Click Event
    
    @IBAction func onClickBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickRegister(sender: UIButton) {
        userManager.m_strEmail = txtEmail.text!
        userManager.m_strPassword = txtPassword.text!
        userManager.m_strFirstName = txtFirstname.text!
        userManager.m_strLastName = txtLastname.text!
        userManager.m_strPhone = txtPhone.text!
        userManager.m_strAddress1 = txtAddress.text!
        userManager.m_strCity = txtCity.text!
        userManager.m_strZipcode = txtZipcode.text!
        userManager.m_strState = txtState.text!
        userManager.m_strCountry = txtCountry.text!
        self._register()
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
