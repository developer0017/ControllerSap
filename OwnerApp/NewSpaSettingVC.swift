//
//  NewSpaSettingVC.swift
//  OwnerApp
//
//  Created by Star Developer on 5/22/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class NewSpaSettingVC: UIViewController, SpaSettingTemperatureCellDelegate, SpaSettingComponentCellDelegate {

    let spaManager = BWGSpaManager.sharedInstance
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblSpaSetting: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var index : Int = -1
    var strTitle: String = ""
    var mySpaSettingModel = MySpaSettingModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSave.layer.cornerRadius = 8.0
        btnSave.layer.borderWidth = 1.0
        btnSave.layer.borderColor = UIColor.whiteColor().CGColor
        btnSave.layer.masksToBounds = true
        lblTitle.text = strTitle
        self.initModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Click Event
    @IBAction func onClickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onClickSave(sender: AnyObject) {
        Utility.showMessage(self.view, text: "Saving...")
        if index == -1 {
            spaManager.requestSaveSpaSettings(mySpaSettingModel, callback: { (status) in
                Utility.hideMessage(self.view)
                switch status {
                case .SUCCESS_WITH_NO_ERROR:
                    print("Success in SaveSpaSettings")
                    self.navigationController?.popViewControllerAnimated(true)
                    break
                case .ERROR_INVALID_REQUEST: //HTTP Error: 409
                    self._showAlert("Already has the maximum number of presets, please delete one first.")
                    break
                default:
                    print("Error occured while saving.")
                    break
                }
            })
        } else {
            spaManager.requestUpdateSpaRecipe(self.index, callback: { (status) in
                Utility.hideMessage(self.view)
                switch status {
                case .SUCCESS_WITH_NO_ERROR:
                    print("Success in UpdateSpaRecipe")
                    break
                case .ERROR_INVALID_REQUEST: //Token expires.
                    print("Error in UpdateSpaRecipe")
                    break
                default:
                    print("Default in UpdateSpaRecipe")
                    break
                }
            })
        }
    }

    // MARK: - Internal Method
    internal func initModel() {
        if index != -1 {
            mySpaSettingModel = spaManager.arrMySpaSettings[index]
            self.lblTitle.text = mySpaSettingModel.strName
            return
        }
        mySpaSettingModel.strName = self.strTitle
        mySpaSettingModel.temperature = spaManager.m_DesiredTemp
        for component in spaManager.m_components {
            let temp = SpaComponentModel()
            temp.componentType = component["componentType"].stringValue
            if temp.componentType == "HEATER" || temp.componentType == "AV" || temp.componentType == "UV" || temp.componentType == "CIRCULATION_PUMP"
            {
                continue;
            }
            temp.name = component["name"].stringValue
            temp.deviceNumber = component["port"].intValue
            temp.value = ControlState(rawValue: component["value"].stringValue)!
            temp.availableValues = component["availableValues"].arrayObject as! [String]
            mySpaSettingModel.arrComponents.append(temp)
        }
    }
    internal func _showAlert(msg: String) {
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

    // MARK: - SpaSettingTemperatureCellDelegate
    func didChangedTemperature(temperature: Int) {
        mySpaSettingModel.temperature = temperature
    }
    // MARK: - SpaSettingComponentCellDelegate
    func didChangedComponentState(cell: SpaSettingComponentCell) {
        let index = (self.tblSpaSetting.indexPathForCell(cell)?.row)! as Int
        mySpaSettingModel.arrComponents[index].value = cell.value
    }
    

}
extension NewSpaSettingVC : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
}

extension NewSpaSettingVC : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        } else {
            return mySpaSettingModel.arrComponents.count;
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SpaSettingTemperatureCell", forIndexPath: indexPath) as! SpaSettingTemperatureCell
            cell.temperature = mySpaSettingModel.temperature
            cell.initUI()
            cell.delegate = self
            return cell
        } else {
            let component = mySpaSettingModel.arrComponents[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("SpaSettingComponentCell", forIndexPath: indexPath) as! SpaSettingComponentCell
            cell.name = component.name
            cell.componentType = component.componentType
            cell.deviceNumber = component.deviceNumber
            cell.value = component.value
            cell.availableValues = component.availableValues    
            cell.initUI()
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //For iPad, cell's background is white by default.
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
    }
}
