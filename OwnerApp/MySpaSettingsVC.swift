//
//  MySpaSettings.swift
//  OwnerApp
//
//  Created by Star Developer on 5/22/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class MySpaSettingsVC: UIViewController {
    
    let spaManager = BWGSpaManager.sharedInstance

    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var tblSpaSettings: UITableView!
    
    var strNewName: String = ""
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnAddNew.layer.cornerRadius = 8.0
        btnAddNew.layer.borderWidth = 1.0
        btnAddNew.layer.borderColor = UIColor.whiteColor().CGColor
        btnAddNew.layer.masksToBounds = true
//        if spaManager.arrMySpaSettings.count == 0 {
//            self.getSpaSettings()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.getSpaSettings()
        //tblSpaSettings.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        
    }

    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    
    @IBAction func onClickAddNew(sender: AnyObject) {
        index = -1 //Means AddNew
        let alertController = UIAlertController(title: "My New SPA Setting", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter a name."
        }
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            let textField = alertController.textFields![0] as UITextField
            self.strNewName = textField.text!
            self.performSegueWithIdentifier("segueToNewSpaSetting", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - SpaSettingCellDelegate
    func onClickDelete(sender: UIButton) {
        index = sender.tag
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            let setting = self.spaManager.arrMySpaSettings[self.index]
            
            Utility.showMessage(self.view, text: "Deleting...")
            self.spaManager.requestDeleteSpaRecipe(setting.strId, callback: { (status) in
                Utility.hideMessage(self.view)
                switch status {
                case .SUCCESS_WITH_NO_ERROR:
                    print("Success in DeleteSpaSettings")
                    self.spaManager.arrMySpaSettings.removeAtIndex(self.index)
                    self.tblSpaSettings.reloadData()
                    break
                case .ERROR_INVALID_REQUEST: //Token expires.
                    print("Error in DeleteSpaSettings")
                    self._showAlert("Unable to delete a recipe.")
                    break
                default:
                    print("Default in DeleteSpaSettings")
                    break
                }
            })
            
            self.tblSpaSettings.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func onClickCalendar(sender: UIButton) {
        index = sender.tag
        self.performSegueWithIdentifier("segueToSchedule", sender: self)
    }
    func onClickEdit(sender: UIButton)
    {
        index = sender.tag
        self.performSegueWithIdentifier("segueToNewSpaSetting", sender: self)
    }
    func onClickRun(sender: UIButton)
    {
        index = sender.tag
        let setting = spaManager.arrMySpaSettings[sender.tag]
        
        Utility.showMessage(self.view, text: "Please wait...")
        spaManager.requestRunSpaRecipe(setting.strId) { (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Success in RunSpaRecipe")
                self._showAlert("The setting has been applied.")
                break
            default:
                print("Fail in RunSpaRecipe")
                self._showAlert("Unable to run a recipe.")
                break
            }
        }
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueToNewSpaSetting")
        {
            // Get reference to the destination view controller
            let vc = segue.destinationViewController as! NewSpaSettingVC
            vc.index = self.index
            vc.strTitle = strNewName
        }
        if (segue.identifier == "segueToSchedule")
        {
            let vc = segue.destinationViewController as! ScheduleVC
            vc.index = self.index
        }
    }
    
    // MARK: - Internal Methods
    internal func getSpaSettings() {
        Utility.showMessage(self.view, text: "Loading...")
        spaManager.requestGetSpaSettings({ (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Success in getSpaSettings")
                self.tblSpaSettings.reloadData()
                break
            default:
                print("Fail in getSpaSettings")
                break
            }
        })

    }
    internal func duplication_check(newName: String)->Bool {
        var result:Bool = false
        for setting in spaManager.arrMySpaSettings {
            if setting.strName == newName {
                result = true
                break
            }
        }
        return result
    }
    internal func _showAlert(msg: String) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
extension MySpaSettingsVC : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
}

extension MySpaSettingsVC : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if spaManager.arrMySpaSettings.isEmpty {
            let lblMessage = UILabel(frame: CGRectMake(0, 0, self.tblSpaSettings.bounds.size.width, self.tblSpaSettings.bounds.size.height))
            lblMessage.text = "No data is available."
            lblMessage.textColor = UIColor.whiteColor()
            lblMessage.textAlignment = NSTextAlignment.Center
            lblMessage.font = UIFont(name:"HelveticaNeue", size:20)
            lblMessage.sizeToFit()
            tableView.backgroundView = lblMessage
            tableView.separatorStyle = .None
            return 0
        } else {
            tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaManager.arrMySpaSettings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let setting = spaManager.arrMySpaSettings[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("SpaSettingCell", forIndexPath: indexPath) as! SpaSettingCell
        cell.lblName.text = setting.strName
        if setting.strName == "Turn Off Spa" {
            cell.btnEdit.enabled = false
            cell.btnDelete.enabled = false
        }
        cell.btnRun.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnCalendar.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnRun.addTarget(self, action: #selector(onClickRun), forControlEvents: .TouchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(onClickEdit), forControlEvents: .TouchUpInside)
        cell.btnCalendar.addTarget(self, action: #selector(onClickCalendar), forControlEvents: .TouchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let setting = spaManager.arrMySpaSettings[indexPath.row]
        spaManager.requestRunSpaRecipe(setting.strId) { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Success in RunSpaRecipe")
                break
            default:
                print("Fail in RunSpaRecipe")
                break
            }
        }
        
    }
    //For iPad, cell's background is white by default.
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
    }
}
