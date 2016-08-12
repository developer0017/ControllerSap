//
//  ViewController.swift
//  OwnerApp
//
//  Created by Adam on 3/30/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import DLRadioButton

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //Color
    let PLACEHOLDER_COLOR = UIColor.grayColor()//UIColor(red: 90.0/255.0, green: 120.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    let userManager = BWGUserManager.sharedInstance
    let tokenManager = BWGTokenManager.sharedInstance

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnNetworkSettings: UIButton!
    
    @IBOutlet weak var checkRememberPassword: DLRadioButton!
    @IBOutlet weak var imgBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnSignIn.layer.cornerRadius = 8.0
        btnSignIn.layer.borderWidth = 1.0
        btnSignIn.layer.borderColor = UIColor.whiteColor().CGColor
        btnSignIn.layer.masksToBounds = true
        
        btnRegister.layer.cornerRadius = 8.0
        btnRegister.layer.borderWidth = 1.0
        btnRegister.layer.borderColor = UIColor.whiteColor().CGColor
        btnRegister.layer.masksToBounds = true
        
        btnNetworkSettings.layer.cornerRadius = 8.0
        btnNetworkSettings.layer.borderWidth = 1.0
        btnNetworkSettings.layer.borderColor = UIColor.whiteColor().CGColor
        btnNetworkSettings.layer.masksToBounds = true
        
        //Add blur to background.
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = imgBackground.bounds
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        blurEffectView.alpha = 0.5
//        imgBackground.addSubview(blurEffectView)
        
        let strEmailPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName:PLACEHOLDER_COLOR])
        txtUsername.attributedPlaceholder = strEmailPlaceholder
        let strPasswordPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:PLACEHOLDER_COLOR])
        txtPassword.attributedPlaceholder = strPasswordPlaceholder
        checkRememberPassword.multipleSelectionEnabled = true
        
        txtPassword.delegate = self
        
        //Hide keyboard by touching anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(_dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Auto Login
        if userManager.loadUserLoginFromLocalStorage() {
            txtUsername.text = userManager.m_strUsername
            txtPassword.text = userManager.m_strPassword
            tokenManager.m_username = userManager.m_strUsername
            tokenManager.m_password = userManager.m_strPassword
            _signIn()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtPassword {
            userManager.m_strUsername = txtUsername.text!
            userManager.m_strPassword = txtPassword.text!
            tokenManager.m_username = txtUsername.text!
            tokenManager.m_password = txtPassword.text!
            _signIn()
        }
        textField.resignFirstResponder()
        return true
    }

    
    // MARK: - Click Event
    @IBAction func onClickSignIn(sender: UIButton) {
        self._dismissKeyboard()
        if txtUsername.text == ""{
            self._showAlert("Please enter username.")
            return
        }
        if txtPassword.text == "" {
            self._showAlert("Please enter password.")
            return
        }
        
        //Email Validation
//        if !Utility.isValidEmail(txtUsername.text!) {
//            self._showAlert("Please enter valid email address.")
//            return
//        }
        
        userManager.m_strUsername = txtUsername.text!
        userManager.m_strPassword = txtPassword.text!
        tokenManager.m_username = txtUsername.text!
        tokenManager.m_password = txtPassword.text!
        if BWGSpaManager.sharedInstance.m_bRegistered {
            _signIn()
        } else {
            _registerSpaToExistingUser()
        }
        
    }
    
    @IBAction func onClickNetworkSettings(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let networkSettingsVC = storyboard.instantiateViewControllerWithIdentifier("NetworkSettingsVC") as! NetworkSettingsVC
        networkSettingsVC.fromLoginVC = true
        self.navigationController?.pushViewController(networkSettingsVC, animated: true)
    }
    
    @IBAction func onCheckRememberPassword(sender: DLRadioButton) {
       
    }
    // MARK: - Internal methods
    internal func _showAlert(msg: String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func _dismissKeyboard() {
        view.endEditing(true)
    }
    private func _registerSpaToExistingUser() {
        Utility.showMessage(self.view, text: "Login in progress...")
        tokenManager.requestTokenEndpointWithCallback { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.tokenManager.requestAccessToken({ (status) in
                    switch status {
                    case .SUCCESS_WITH_NO_ERROR:
                        if(self.checkRememberPassword.selected)
                        {
                            self.userManager.saveUserLoginToLocalStorage()
                        }
                        self.userManager.requestRegisterExistingUserWithCallback({ (status) in
                                Utility.hideMessage(self.view)
                                if(status == ERROR_CODE.SUCCESS_WITH_NO_ERROR)
                                {
                                    self.performSegueWithIdentifier("segueToTempDirectly", sender: self)
                                } else {
                                    self.performSegueWithIdentifier("segueToTAC", sender: self)
                                }
                            
                        })
                        break
                    default:
                        Utility.hideMessage(self.view)
                        self._showAlert("Your login details are incorrect.")
                        break
                    }
                })
                
                break
            default:
                Utility.hideMessage(self.view)
                self._showAlert("Error, please try again.")
                break
            }
            
        }
        return
    }
    
    private func _signIn() {
        //Test only
//        if true {
//            self.performSegueWithIdentifier("segueToTempDirectly", sender: self)
//            return
//        }

        //Token based authentication
        Utility.showMessage(self.view, text: "Login in progress...")
        tokenManager.requestTokenEndpointWithCallback { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.tokenManager.requestAccessToken({ (status) in
                    switch status {
                    case .SUCCESS_WITH_NO_ERROR:
                        if(self.checkRememberPassword.selected)
                        {
                            self.userManager.saveUserLoginToLocalStorage()
                        }
                        self.userManager.requestWhoAmI({ (status) in
                            switch status {
                            case .SUCCESS_WITH_NO_ERROR:
                                self.userManager.requestFindCurrentUserAgreement({ (status) in
                                    Utility.hideMessage(self.view)
                                    if(status == TAC_CODE.AGREED)
                                    {
                                        self.performSegueWithIdentifier("segueToTempDirectly", sender: self)
                                    } else {
                                        self.performSegueWithIdentifier("segueToTAC", sender: self)
                                    }
                                })
                                break
                            default:
                                Utility.hideMessage(self.view)
                                self._showAlert("Error, please try again.")
                                break
                            }
                            
                        })
                        break
                    default:
                        Utility.hideMessage(self.view)
                        self._showAlert("Your login details are incorrect.")
                        break
                    }
                })
                
                break
            default:
                Utility.hideMessage(self.view)
                self._showAlert("Error, please try again.")
                break
            }
            
        }
        return
        
        
        /*Utility.showMessage(self.view, text: "Login in progress...")
        userManager.requestLoginWithCallback { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.txtPassword.text = ""
                if(self.checkRememberPassword.selected)
                {
                    self.userManager.saveUserLoginToLocalStorage()
                }
                self.userManager.requestFindCurrentUserAgreement({ (status) in
                    Utility.hideMessage(self.view)
                    if(status == TAC_CODE.AGREED)
                    {
                        self.performSegueWithIdentifier("segueToTempDirectly", sender: self)
                    } else {
                        self.performSegueWithIdentifier("segueToTAC", sender: self)
                    }
                })
                break
//            case .ERROR_INVALID_REQUEST:
//            case .ERROR_INVALID_PARAMETER:
//            case .ERROR_CONNECTION_FAILED:
            default:
                Utility.hideMessage(self.view)
                self._showAlert("Login failed, please try again.")
                break
            }
        }*/
        
    }
    

}

