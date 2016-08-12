//
//  NetworkSettingsVC.swift
//  OwnerApp
//
//  Created by Star Developer on 6/23/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import DropDown
import SwiftValidator

class NetworkSettingsVC: UIViewController {
    let networkManager = BWGNetworkManager.sharedInstance
    let validator = Validator()

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    
    @IBOutlet weak var txtSSID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtIPAddress: UITextField!
    @IBOutlet weak var txtSubnetMask: UITextField!
    @IBOutlet weak var txtGateway: UITextField!
    
    @IBOutlet weak var viewSSID: UIView!
    @IBOutlet weak var viewEthernet: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblDHCP: UILabel!
    
    let cbDHCP = DropDown()
    let arrDHCP = ["Manual", "DHCP"]
    var fromLoginVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
        self.btnSave.enabled = false
        self.btnSave.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.registerValidator()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Click Event
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    
    @IBAction func onClickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onClickDHCP(sender: AnyObject) {
        cbDHCP.show()
    }
    @IBAction func onClickTest(sender: AnyObject) {
        self._getNetworkSettings()
    }
    
    @IBAction func onClickSave(sender: AnyObject) {
        txtIPAddress.backgroundColor = UIColor.whiteColor()
        txtSubnetMask.backgroundColor = UIColor.whiteColor()
        txtGateway.backgroundColor = UIColor.whiteColor()
        if lblDHCP.text == "Manual" {
            validator.validate { (errors) in
                if errors.count == 0 {
                    print("Validation Success")
                    self._putNetworkSettings()
                } else {
                    for (field, _) in errors {
                        if let field = field as? UITextField {
                            field.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
                        }
                    }
                }
            }
        } else {
            self._putNetworkSettings()
        }
    }
    

    // MARK: - Internal methods
    private func initUI() {
        self.btnMenu.hidden = fromLoginVC
        self.btnBack.hidden = !fromLoginVC
        
        cbDHCP.anchorView = lblDHCP
        cbDHCP.dataSource = arrDHCP
        cbDHCP.selectionAction = { [unowned self] (index, item) in
            self.lblDHCP.text = item
            if item == "DHCP" {
                self.txtIPAddress.enabled = false
                self.txtSubnetMask.enabled = false
                self.txtGateway.enabled = false
            } else {
                self.txtIPAddress.enabled = true
                self.txtSubnetMask.enabled = true
                self.txtGateway.enabled = true
            }
        }
        cbDHCP.selectRowAtIndex(0)
        cbDHCP.textColor = UIColor(red: 24.0/255, green: 71/255, blue: 110.0/255, alpha: 1.0)
        cbDHCP.selectionBackgroundColor = UIColor(red: 80.0/255, green: 180.0/255, blue: 240.0/255, alpha: 0.8)
        
        let cornerRadius: CGFloat = 8.0
        btnSave.layer.cornerRadius = cornerRadius
        btnSave.layer.borderWidth = 1.0
        btnSave.layer.borderColor = UIColor.whiteColor().CGColor
        btnSave.layer.masksToBounds = true
        
        btnTest.layer.cornerRadius = cornerRadius
        btnTest.layer.borderWidth = 1.0
        btnTest.layer.borderColor = UIColor.whiteColor().CGColor
        btnTest.layer.masksToBounds = true
        
        viewSSID.layer.cornerRadius = 5.0
        viewSSID.layer.masksToBounds = true
        viewSSID.layer.backgroundColor = bgColor.CGColor
        
        viewEthernet.layer.cornerRadius = 5.0
        viewEthernet.layer.masksToBounds = true
        viewEthernet.layer.backgroundColor = bgColor.CGColor
        
        viewContainer.layer.cornerRadius = 5.0
        viewContainer.layer.masksToBounds = true
        viewContainer.layer.backgroundColor = bgColor.CGColor
    }
    private func registerValidator() {
        validator.registerField(txtIPAddress, rules: [IPV4Rule()])
        validator.registerField(txtSubnetMask, rules: [IPV4Rule()])
        validator.registerField(txtGateway, rules: [IPV4Rule()])
        
    }
    private func _getNetworkSettings()
    {
        Utility.showMessage(self.view, text: "Please wait...")
        self.networkManager.requestGetNetworkSettingsWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self._showAlert("Success")
                //self.txtSSID.text = self.networkManager.m_SSID
                self.txtIPAddress.text = self.networkManager.m_IPAddress
                self.txtSubnetMask.text = self.networkManager.m_SubnetMask
                self.txtGateway.text = self.networkManager.m_Gateway
                if self.networkManager.m_DHCP {
                    self.lblDHCP.text = "DHCP"
                    self.cbDHCP.selectRowAtIndex(1)
                    self.txtIPAddress.enabled = false
                    self.txtSubnetMask.enabled = false
                    self.txtGateway.enabled = false
                } else {
                    self.lblDHCP.text = "Manual"
                    self.cbDHCP.selectRowAtIndex(0)
                    self.txtIPAddress.enabled = true
                    self.txtSubnetMask.enabled = true
                    self.txtGateway.enabled = true
                }
                self.btnSave.enabled = true
                self.btnSave.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                break
            default:
                self._showAlert("Please follow the instructions and try again.")
                break
            }
        })
    }
    private func _putNetworkSettings()
    {
        //TODO Validation.
        networkManager.m_SSID = self.txtSSID.text!
        networkManager.m_Password = self.txtPassword.text!
        networkManager.m_IPAddress = self.txtIPAddress.text!
        networkManager.m_SubnetMask = self.txtSubnetMask.text!
        networkManager.m_Gateway = self.txtGateway.text!
        networkManager.m_DHCP = (self.lblDHCP.text == "DHCP")
        
        Utility.showMessage(self.view, text: "Saving...")
        self.networkManager.requestPutNetworkSettingsWithCallback({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Done Network settings")
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    if self.fromLoginVC {
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        let leftVC = self.slideMenuController()?.leftViewController as? LeftVC
                        let tempVC = leftVC?.tempVC as! TempVC
                        self.slideMenuController()?.changeMainViewController(tempVC, close: true)

                    }
                }
                self._showAlertWithAction("Success", strMsg: "", action: okAction)
                break
            default:
                self._showAlert("Please try again later.")
                break
            }
        })
    }
    
    private func _showAlert(msg: String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    private func _showAlertWithAction(strTitle: String, strMsg: String, action: UIAlertAction) {
        let alertController = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .Alert)
        alertController.addAction(action)
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
