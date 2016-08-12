//
//  LeftVC.swift
//  OwnerApp
//
//  Created by Adam on 5/9/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case TempVC = 0
    case ControlsVC
    case AccountVC
    case SpaDetailsVC
    case LocationVC
    case MySpaSettingsVC
    case NetworkSettingsVC
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftVC: UIViewController, LeftMenuProtocol {

    @IBOutlet weak var tblMenu: UITableView!
    
    //var menus = ["Temp", "Controls", "Account setting", "Log out"]
    var arrMenuItems = [MenuItemModel]()
    var tempVC: UIViewController!
    var controlsVC: UIViewController!
    var accountVC: UIViewController!
    var spaDetailsVC: UIViewController!
    var locationVC: UIViewController!
    var mySpaSettingsVC: UIViewController!
    var networkSettingsVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupMenu()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //tempVC is initialized in ContainerVC
        //self.tempVC = storyboard.instantiateViewControllerWithIdentifier("TempVC") as! TempVC
        self.controlsVC = storyboard.instantiateViewControllerWithIdentifier("ControlsVC") as! ControlsVC
        self.accountVC = storyboard.instantiateViewControllerWithIdentifier("AccountVC") as! AccountVC
        self.spaDetailsVC = storyboard.instantiateViewControllerWithIdentifier("SpaDetailsVC") as! SpaDetailsVC
        self.locationVC = storyboard.instantiateViewControllerWithIdentifier("LocationVC") as! LocationVC
        self.mySpaSettingsVC = storyboard.instantiateViewControllerWithIdentifier("MySpaSettingsVC") as! MySpaSettingsVC
        self.networkSettingsVC = storyboard.instantiateViewControllerWithIdentifier("NetworkSettingsVC") as! NetworkSettingsVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupMenu() {
        let menu1 = MenuItemModel(title: "Temperature", icon: "icon_temperature")
        let menu2 = MenuItemModel(title: "Controls", icon: "icon_controls")
        let menu3 = MenuItemModel(title: "Account settings", icon: "icon_account")
        let menu4 = MenuItemModel(title: "Spa details", icon: "icon_details")
        let menu5 = MenuItemModel(title: "See my location", icon: "icon_location")
        let menu6 = MenuItemModel(title: "Presets and Scheduling", icon: "icon_setting")
        let menu7 = MenuItemModel(title: "Network Settings", icon: "icon_network")
        
        arrMenuItems = [menu1, menu2, menu3, menu4, menu5, menu6, menu7]
        
        
    }
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .TempVC:
            self.slideMenuController()?.changeMainViewController(self.tempVC, close: true)
        case .ControlsVC:
            self.slideMenuController()?.changeMainViewController(self.controlsVC, close: true)
        case .AccountVC:
            self.slideMenuController()?.changeMainViewController(self.accountVC, close: true)
        case .SpaDetailsVC:
            self.slideMenuController()?.changeMainViewController(self.spaDetailsVC, close: true)
        case .LocationVC:
            self.slideMenuController()?.changeMainViewController(self.locationVC, close: true)
            break
        case .MySpaSettingsVC:
            self.slideMenuController()?.changeMainViewController(self.mySpaSettingsVC, close: true)
            break
        case .NetworkSettingsVC:
            self.slideMenuController()?.changeMainViewController(self.networkSettingsVC, close: true)
            break
        }
    }

    // MARK: - Click Event
    
    @IBAction func onLogout(sender: AnyObject) {
        BWGSpaManager.sharedInstance.initializeManager()
        BWGUserManager.sharedInstance.initializeManager()
        self.navigationController?.popToRootViewControllerAnimated(true)
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
extension LeftVC : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48;
    }
}

extension LeftVC : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuCell")!
        let lbl = cell.viewWithTag(100) as! UILabel
        lbl.text = arrMenuItems[indexPath.row].title
        let icon = cell.viewWithTag(101) as! UIImageView
        icon.image = UIImage(named: arrMenuItems[indexPath.row].icon)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    //For iPad, cell's background is white by default.
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
    }
}
