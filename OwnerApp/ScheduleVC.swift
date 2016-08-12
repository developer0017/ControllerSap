//
//  ScheduleVC.swift
//  OwnerApp
//
//  Created by Star Developer on 5/26/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import FSCalendar
import STPopup
import M13Checkbox
import DropDown
//import MZFormSheetPresentationController

class ScheduleVC: UIViewController, TimePickerDelegate, RepeatDelegate, FSCalendarDelegate, FSCalendarDataSource {
    
    let spaManager = BWGSpaManager.sharedInstance

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblStopTime: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblRepeat: UILabel!
    
    @IBOutlet weak var chkEnable: M13Checkbox!
    
    let cbDuration = DropDown()
    
    var index: Int = -1
    var isStart = true
    
    var mySpaSettingModel = MySpaSettingModel()
    var startDate = ""
    var endDate = ""
    
    let arrDuration = ["30 mins", "45 mins", "60 mins", "90 mins", "120 mins"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //calendar.dataSource = self
        calendar.delegate = self
        
        chkEnable.boxType = .Square
        btnSave.layer.cornerRadius = 8.0
        btnSave.layer.borderWidth = 1.0
        btnSave.layer.borderColor = UIColor.whiteColor().CGColor
        btnSave.layer.masksToBounds = true
        
        cbDuration.anchorView = lblDuration
        cbDuration.dataSource = arrDuration
        cbDuration.selectionAction = { [unowned self] (index, item) in
            self.lblDuration.text = item
        }
        cbDuration.selectRowAtIndex(0)
        cbDuration.backgroundColor = UIColor(red: 30.0/255, green: 90.0/255, blue: 120.0/255, alpha: 1.0)
        cbDuration.textColor = UIColor.whiteColor()
        cbDuration.selectionBackgroundColor = UIColor(red: 60.0/255, green: 150.0/255, blue: 210.0/255, alpha: 0.8)
        
        
        if index != -1 {
            mySpaSettingModel = spaManager.arrMySpaSettings[index]
            self.lblTitle.text = mySpaSettingModel.strName
            if mySpaSettingModel.durationMinutes == 0 {
                mySpaSettingModel.durationMinutes = 30
            }
            if mySpaSettingModel.bEnabled {
                chkEnable.checkState = .Checked
            }
            
            
            if mySpaSettingModel.strCronExpression != "" { //New schedule or Not
                let params = mySpaSettingModel.strCronExpression.componentsSeparatedByString(" ")
                //Current Date
                let cDate = NSDate()
                let cDay = NSCalendar.currentCalendar().component(.Day, fromDate: cDate)
                let cMonth = NSCalendar.currentCalendar().component(.Month, fromDate: cDate)
                let cDayOfWeek = NSCalendar.currentCalendar().component(.Weekday, fromDate: cDate)
                let cYear = NSCalendar.currentCalendar().component(.Year, fromDate: cDate)
                
                let minute = params[1]
                let hour = params[2]
                let day = params[3]
                let month = params[4]
                let dayOfWeek = params[5]
                
                if month == "*" && day == "*" && dayOfWeek == "?" { //Daily
                    mySpaSettingModel.strMode = "Daily"
                    calendar.selectDate(NSDate())
                } else if month == "*" && day == "*" {
                    mySpaSettingModel.strMode = "Weekly"
                    
                    let components = NSDateComponents()
                    
                    if cDayOfWeek > Int(dayOfWeek)! {
                        components.setValue(Int(dayOfWeek)!+7-cDayOfWeek, forComponent: NSCalendarUnit.Day)
                    } else {
                        components.setValue(Int(dayOfWeek)!-cDayOfWeek, forComponent: NSCalendarUnit.Day)
                    }
                    let nextDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: cDate, options: NSCalendarOptions(rawValue: 0))!
                    calendar.selectDate(nextDate)
                } else if month == "*" && dayOfWeek == "?" {
                    mySpaSettingModel.strMode = "Monthly"
                    
                    let components = NSDateComponents()
                    components.month = cMonth
                    components.day = Int(day)!
                    components.year = cYear
                    
                    if cDay > Int(day)! {
                        components.month = cMonth + 1
                    }
                    let nextDate = NSCalendar.currentCalendar().dateFromComponents(components)!
                    calendar.selectDate(nextDate)
                } else {
                    mySpaSettingModel.strMode = "None"
                    
                    let components = NSDateComponents()
                    components.month = Int(month)!
                    components.day = Int(day)!
                    components.year = cYear
                    let nextDate = NSCalendar.currentCalendar().dateFromComponents(components)!
                    calendar.selectDate(nextDate)
                }
                lblRepeat.text = mySpaSettingModel.strMode
                
                //Set Start time.
                let dateComponents = NSDateComponents()
                dateComponents.hour = Int(hour)!
                dateComponents.minute = Int(minute)!
                let time = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let strTime = dateFormatter.stringFromDate(time)
                lblStartTime.text = strTime
                
                //Set Duration
                switch mySpaSettingModel.durationMinutes {
                case 30:
                    cbDuration.selectRowAtIndex(0)
                    break
                case 45:
                    cbDuration.selectRowAtIndex(1)
                    break
                case 60:
                    cbDuration.selectRowAtIndex(2)
                    break
                case 90:
                    cbDuration.selectRowAtIndex(3)
                    break
                case 120:
                    cbDuration.selectRowAtIndex(4)
                    break
                default:
                    cbDuration.selectRowAtIndex(0)
                    break
                }
                
                //Set StartDate, EndDate
                if self.mySpaSettingModel.strStartDate != "" && self.mySpaSettingModel.strEndDate != ""{
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let startDate = dateFormatter.dateFromString(self.mySpaSettingModel.strStartDate)!
                    let endDate = dateFormatter.dateFromString(self.mySpaSettingModel.strEndDate)!
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.startDate = dateFormatter.stringFromDate(startDate)
                    self.endDate = dateFormatter.stringFromDate(endDate)
                }
            } else {
                calendar.selectDate(NSDate())
            }
            
            
        }

        
      
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
        self._setParameters()
        Utility.showMessage(self.view, text: "Saving...")
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
    @IBAction func onClickStartTime(sender: AnyObject) {
        isStart = true
        let timePickerController = self.storyboard!.instantiateViewControllerWithIdentifier("TimePickerController") as! TimePickerPopupVC
        timePickerController.title = "Start Time"
        timePickerController.delegate = self
        let popup = STPopupController.init(rootViewController: timePickerController)
        popup.containerView.layer.cornerRadius = 10
        
        STPopupNavigationBar.appearance().barTintColor = UIColor(red: 20/255, green: 50/255, blue: 90/255, alpha: 1.0)
        STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        popup.presentInViewController(self)
    }
    
    @IBAction func onClickStopTime(sender: AnyObject) {
        isStart = false
        let timePickerPopup = self.storyboard!.instantiateViewControllerWithIdentifier("TimePickerPopupVC") as! TimePickerPopupVC
        timePickerPopup.title = "Stop Time"
        timePickerPopup.delegate = self
        let popup = STPopupController.init(rootViewController: timePickerPopup)
        popup.containerView.layer.cornerRadius = 10
        
        STPopupNavigationBar.appearance().barTintColor = UIColor(red: 20/255, green: 50/255, blue: 90/255, alpha: 1.0)
        STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        popup.presentInViewController(self)
    }

    @IBAction func onClickDuration(sender: AnyObject) {
        cbDuration.show()
    }
    @IBAction func onClickRepeat(sender: AnyObject) {
        let repeatPopup = self.storyboard!.instantiateViewControllerWithIdentifier("RepeatPopupVC") as! RepeatPopupVC
        repeatPopup.title = "Choose options"
        repeatPopup.strStart = startDate
        repeatPopup.strEnd = endDate
        repeatPopup.strMode = mySpaSettingModel.strMode
        repeatPopup.delegate = self
        
        let popup = STPopupController.init(rootViewController: repeatPopup)
        popup.containerView.layer.cornerRadius = 10
        
        STPopupNavigationBar.appearance().barTintColor = UIColor(red: 20/255, green: 50/255, blue: 90/255, alpha: 1.0)
        STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        popup.presentInViewController(self)
        
    }
    //MARK: - TimePickerDelegate, RepeatDelegate
    func didSelectTime(strTime: String) {
        if isStart {
            lblStartTime.text = strTime
            
        } else {
            lblStopTime.text = strTime
        }
        //TODO check start < stop
    }
    func didSelectDates(strStart: String, strEnd: String, strMode: String) {
        self.startDate = strStart
        self.endDate = strEnd
        self.lblRepeat.text = strMode
        mySpaSettingModel.strMode = strMode
    }
    
    //MARK: - FSCalendar delegate
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
    }
    
    // MARK: - Internal methods
    func _setParameters() {
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'h:mm a"
        
        //Generate strStartDate, strEndDate from starttime, endtime, startDate and endDate
        if !startDate.isEmpty {
            mySpaSettingModel.strStartDate = startDate
        }
        if !endDate.isEmpty {
            mySpaSettingModel.strEndDate = endDate
        } 
        mySpaSettingModel.bEnabled = (chkEnable.checkState == .Checked)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let startTime = timeFormatter.dateFromString(lblStartTime.text!)!
        
        let selectedDate = self.calendar.selectedDate
        
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: startTime)
        let minute = NSCalendar.currentCalendar().component(.Minute, fromDate: startTime)
        let day = NSCalendar.currentCalendar().component(.Day, fromDate: selectedDate)
        let month = NSCalendar.currentCalendar().component(.Month, fromDate: selectedDate)
        let year = NSCalendar.currentCalendar().component(.Year, fromDate: selectedDate)
        let dayOfWeek = NSCalendar.currentCalendar().component(.Weekday, fromDate: selectedDate)
        
        let strDuration = lblDuration.text!
        let temp = strDuration.componentsSeparatedByString(" ")
        mySpaSettingModel.durationMinutes = Int(temp[0])!
        mySpaSettingModel.strTimeZone = NSTimeZone.localTimeZone().name
       
        let expression: String
        switch mySpaSettingModel.strMode {
        case "Daily":
            expression = "0 \(minute) \(hour) * * ?"
            break
        case "Weekly":
            expression = "0 \(minute) \(hour) * * \(dayOfWeek)"
            break
        case "Monthly":
            expression = "0 \(minute) \(hour) \(day) * ?"
            break
        case "None":
            expression = "0 \(minute) \(hour) \(day) \(month) \(dayOfWeek) \(year)"
            break
        default:
            expression = "0 \(minute) \(hour) * * ?"
            break
        }
        mySpaSettingModel.strCronExpression = expression
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
