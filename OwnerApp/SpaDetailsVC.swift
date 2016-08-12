//
//  SpaDetailsVC.swift
//  OwnerApp
//
//  Created by Star Developer on 5/11/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class SpaDetailsVC: BaseVC {

    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductModel: UITextField!
    @IBOutlet weak var txtSerialNumber: UITextField!
    @IBOutlet weak var txtRegistrationDate: UITextField!
    @IBOutlet weak var txtManufacturedDate: UITextField!

    @IBOutlet weak var txtSpaOwner: UITextField!
    @IBOutlet weak var txtTransactionID: UITextField!
    @IBOutlet weak var txtSalesAssociate: UITextField!
    @IBOutlet weak var txtSpaHealth: UITextField!
    @IBOutlet weak var txtSpaMode: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtAPSSID: UITextField!
    
    @IBOutlet weak var txtEquipmentList: UITextField!
    
    
    @IBOutlet weak var viewProductName: UIView!
    @IBOutlet weak var viewProductModel: UIView!
    @IBOutlet weak var viewSerialNumber: UIView!
    @IBOutlet weak var viewRegistrationDate: UIView!
    @IBOutlet weak var viewManufacturedDate: UIView!
    @IBOutlet weak var viewTransactionID: UIView!
    @IBOutlet weak var viewOwnerName: UIView!
    @IBOutlet weak var viewSalesAssociative: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewAPSSID: UIView!
    @IBOutlet weak var viewSpaHealth: UIView!
    @IBOutlet weak var viewRunMode: UIView!
    @IBOutlet weak var viewEquipmentList: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSpaDetails()
        // Do any additional setup after loading the view.
        self.imgBackground.image = UIImage(named: "LaunchBackground")
        self.initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    internal func getSpaDetails() {
        self.txtProductName.text = self.spaManager.m_ProductName
        self.txtProductModel.text = self.spaManager.m_ProductModel
        self.txtSpaOwner.text = self.spaManager.m_OwnerName
        self.txtSerialNumber.text = self.spaManager.m_SerialNumber
        
        if !self.spaManager.m_ManufacturedDate.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let mDate = dateFormatter.dateFromString(self.spaManager.m_ManufacturedDate)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.txtManufacturedDate.text = dateFormatter.stringFromDate(mDate)
        }
        if !self.spaManager.m_RegistrationDate.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let rDate = dateFormatter.dateFromString(self.spaManager.m_RegistrationDate)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.txtRegistrationDate.text = dateFormatter.stringFromDate(rDate)
        }
        
        self.txtTransactionID.text = self.spaManager.m_TransactionID
        self.txtSalesAssociate.text = self.spaManager.m_SalesAssociate
        self.txtSpaMode.text = self.spaManager.m_RunMode
        self.txtAPSSID.text = self.spaManager.m_P2P_AP_SSID
        self.txtLocation.text = self.spaManager.m_Location
    }
    
    // MARK: - Click Event
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    
    // MARK: - Internal Methods
    internal func initUI() {
        viewProductName.layer.cornerRadius = 5.0
        viewProductName.layer.masksToBounds = true
        viewProductName.layer.backgroundColor = bgColor.CGColor
        
        viewProductModel.layer.cornerRadius = 5.0
        viewProductModel.layer.masksToBounds = true
        viewProductModel.layer.backgroundColor = bgColor.CGColor
        
        viewSerialNumber.layer.cornerRadius = 5.0
        viewSerialNumber.layer.masksToBounds = true
        viewSerialNumber.layer.backgroundColor = bgColor.CGColor
        
        viewRegistrationDate.layer.cornerRadius = 5.0
        viewRegistrationDate.layer.masksToBounds = true
        viewRegistrationDate.layer.backgroundColor = bgColor.CGColor
        
        viewManufacturedDate.layer.cornerRadius = 5.0
        viewManufacturedDate.layer.masksToBounds = true
        viewManufacturedDate.layer.backgroundColor = bgColor.CGColor
        
        viewTransactionID.layer.cornerRadius = 5.0
        viewTransactionID.layer.masksToBounds = true
        viewTransactionID.layer.backgroundColor = bgColor.CGColor
        
        viewOwnerName.layer.cornerRadius = 5.0
        viewOwnerName.layer.masksToBounds = true
        viewOwnerName.layer.backgroundColor = bgColor.CGColor
        
        viewSalesAssociative.layer.cornerRadius = 5.0
        viewSalesAssociative.layer.masksToBounds = true
        viewSalesAssociative.layer.backgroundColor = bgColor.CGColor
        
        viewLocation.layer.cornerRadius = 5.0
        viewLocation.layer.masksToBounds = true
        viewLocation.layer.backgroundColor = bgColor.CGColor
        
        viewAPSSID.layer.cornerRadius = 5.0
        viewAPSSID.layer.masksToBounds = true
        viewAPSSID.layer.backgroundColor = bgColor.CGColor
        
        viewSpaHealth.layer.cornerRadius = 5.0
        viewSpaHealth.layer.masksToBounds = true
        viewSpaHealth.layer.backgroundColor = bgColor.CGColor
        
        viewRunMode.layer.cornerRadius = 5.0
        viewRunMode.layer.masksToBounds = true
        viewRunMode.layer.backgroundColor = bgColor.CGColor
        
        viewEquipmentList.layer.cornerRadius = 5.0
        viewEquipmentList.layer.masksToBounds = true
        viewEquipmentList.layer.backgroundColor = bgColor.CGColor
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
