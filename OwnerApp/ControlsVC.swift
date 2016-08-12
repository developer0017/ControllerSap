//
//  ControlsVC.swift
//  OwnerApp
//
//  Created by Adam on 3/31/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class ControlsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, SpaControlCellDelegate, SpaControlCVCellDelegate {
   
    @IBOutlet weak var tblSpaControls: UITableView!
    @IBOutlet weak var cvSpaControls: UICollectionView!
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeRecognizer.direction = .Right
        rightSwipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        
        self.cvSpaControls.registerNib(UINib(nibName: "SpaControlCVCell2", bundle:nil), forCellWithReuseIdentifier: "SpaControlCVCell2")
        self.cvSpaControls.registerNib(UINib(nibName: "SpaControlCVCell3", bundle:nil), forCellWithReuseIdentifier: "SpaControlCVCell3")
        self.cvSpaControls.registerNib(UINib(nibName: "SpaControlCVCell4", bundle:nil), forCellWithReuseIdentifier: "SpaControlCVCell4")
    
    }
    override func viewDidAppear(animated: Bool) {
        self.startTimer()
        self._changeBackground()
    }
    override func viewDidDisappear(animated: Bool) {
        self.stopTimer()
    }
    internal func stopTimer()
    {
        timer?.invalidate()
    }
    internal func startTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(REFRESH_TIME_INTERVAL, target: self, selector: #selector(updateControls), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Click Event
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }

    // MARK: - Gesture Handler
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            
        } else if sender.direction == .Right {            
            let tempVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TempVC") as UIViewController
            self.slideMenuController()?.changeMainViewController(tempVC, close: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaManager.m_components.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let component = spaManager.m_components[indexPath.row]
        switch component["availableValues"].count {
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SpaControlCell2", forIndexPath: indexPath) as! SpaControlCell2
            
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("SpaControlCell1", forIndexPath: indexPath) as! SpaControlCell1
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("SpaControlCell3", forIndexPath: indexPath) as! SpaControlCell3
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let component = spaManager.m_components[indexPath.row]
        if component["availableValues"].count == 2 {
            return 80
        }

        return 105;
    }
    
    //For iPad, cell's background is white by default.
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
    }
    
    // MARK: - SpaControlCellDelegate
    func callSetControlState(cell: SpaControlBaseCell) {
        self.stopTimer()
        
        let index = (self.tblSpaControls.indexPathForCell(cell)?.row)! as Int
        spaManager.m_components[index]["desiredState"].string = cell.desiredState.rawValue
        
        //For filter, it is handled separately.
        if spaManager.m_components[index]["componentType"].stringValue == "FILTER" {
            spaManager.requestSetFilterCycleIntervals(index, callback: { (status) in
                self.startTimer()
            })
        } else {
            //componentType will be checked in requestSetControlState.
            spaManager.requestSetControlState(index, callback: { (status) in
                self.startTimer()
            })
        }
    }
    
    // MARK: - SpaControlCVCellDelegate
    func setControlState(cell: SpaControlCVBaseCell) {
        self.stopTimer()
        
        let index = (self.cvSpaControls.indexPathForCell(cell)?.row)! as Int
        spaManager.m_components[index]["desiredState"].string = cell.desiredState.rawValue
        
        //For filter, it is handled separately.
        if spaManager.m_components[index]["componentType"].stringValue == "FILTER" {
            spaManager.requestSetFilterCycleIntervals(index, callback: { (status) in
                self.startTimer()
            })
        } else {
            //componentType will be checked in requestSetControlState.
            spaManager.requestSetControlState(index, callback: { (status) in
                self.startTimer()
            })
        }
    }
    func showAlert(msg: String) {
        Utility.showAlert(self.view, text: msg)
    }
    
    // MARK: - Timer 
    func updateControls() {
        spaManager.requestFindByUsername(BWGUserManager.sharedInstance.m_strUsername, callback: { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                //self.tblSpaControls.reloadData()
                self.cvSpaControls.reloadData()
                break
            case .ERROR_INVALID_REQUEST: //Token expires.
                self._showSessionExpiredAlert()
                break
            default:
                print("Failed to get spa.")
                break
            }
        })
    }
    func onReadyOrRest(isReady: Bool) {
//        if isReady {
//            backgroundImageView.image = UIImage(named: "Background")
//        } else {
//            backgroundImageView.image = UIImage(named: "RESTBackground")
//        }
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
// MARK: - Extensions

extension ControlsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let component = spaManager.m_components[indexPath.row]
        switch component["availableValues"].count {
        case 2:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpaControlCVCell2", forIndexPath: indexPath) as! SpaControlCVCell2
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpaControlCVCell3", forIndexPath: indexPath) as! SpaControlCVCell3
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpaControlCVCell4", forIndexPath: indexPath) as! SpaControlCVCell4
            cell.name = component["name"].stringValue
            cell.componentType = component["componentType"].stringValue
            cell.deviceNumber = component["port"].intValue
            cell.value = ControlState(rawValue: component["value"].stringValue)!
            if let desiredState = ControlState(rawValue: component["targetValue"].stringValue) {
                cell.desiredState = desiredState
            }
            cell.availableValues = component["availableValues"].arrayObject as! [String]
            cell.initUI()
            cell.delegate = self
            return cell
        default:
            let cell = UICollectionViewCell()
            return cell
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size: CGSize
        let width = collectionView.frame.size.width
        let component = spaManager.m_components[indexPath.row]
        switch component["availableValues"].count {
        case 2:
            size = CGSizeMake(width/3-10, width/3-10)
            break
        case 3, 4:
            size = CGSizeMake(width*7/9+20/3-20, width/3-10)
            break
        default:
            size = CGSizeMake(width/3-10, width/3-10)
            break
        }
        return size
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaManager.m_components.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.size.width
        return UIEdgeInsetsMake(0, width/9+20/3, 20, width/9+20/3)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        //return collectionView.frame.size.width/9+20/3
        return 30
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return collectionView.frame.size.width/9+20/3
    }
}
