//
//  RepeatVC.swift
//  OwnerApp
//
//  Created by polaris on 6/10/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import DropDown

protocol RepeatDelegate {
    func didSelectDates(strStart: String, strEnd: String, strMode: String)
}
class RepeatPopupVC: UIViewController {
    
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    
    var strStart = ""
    var strEnd = ""
    var strMode = ""
    
    var delegate: RepeatDelegate?
    
    let repeatDropDown = DropDown()
    var isStartDate = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        repeatDropDown.anchorView = btnRepeat
        repeatDropDown.dataSource = ["None", "Daily", "Weekly", "Monthly"]
        repeatDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnRepeat.setTitle(item, forState: .Normal)
            if item == "None" {
                self.btnStart.enabled = false
                self.btnEnd.enabled = false
                self.btnStart.setTitle("", forState: .Normal)
                self.btnEnd.setTitle("", forState: .Normal)
                self._hideDatePicker()
            } else {
                self.btnStart.enabled = true
                self.btnEnd.enabled = true
            }
            
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(onClickDone))
        self.contentSizeInPopup = CGSizeMake(300, 320);
        
        datePicker.hidden = true
        //Hide UIDatePicker when touching outside
        let tap = UITapGestureRecognizer(target: self, action: #selector(_hideDatePicker))
        self.view.addGestureRecognizer(tap)
        
        self._initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
    }
    // MARK: - Click Event
    @IBAction func onClickRepeat(sender: AnyObject) {
        repeatDropDown.show()
    }
    
    @IBAction func onClickStart(sender: AnyObject) {
        isStartDate = true
        datePicker.hidden = false
        if !strStart.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.dateFromString(strStart)
            datePicker.setDate(startDate!, animated: true)
        }
    }
    @IBAction func onClickStop(sender: AnyObject) {
        isStartDate = false
        datePicker.hidden = false
        if !strEnd.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let endDate = dateFormatter.dateFromString(strEnd)
            datePicker.setDate(endDate!, animated: true)
        }
    }
    
    func onClickDone() {
        let startDate = btnStart.titleLabel?.text
        let endDate = btnEnd.titleLabel?.text
        if btnRepeat.titleLabel?.text == "None" {
            self.delegate?.didSelectDates("", strEnd: "", strMode: (btnRepeat.titleLabel?.text)!)
        } else if startDate == nil || endDate == nil {
            return
        } else {
            self.delegate?.didSelectDates(startDate!, strEnd: endDate!, strMode: (btnRepeat.titleLabel?.text)!)
        }
        self.popupController.dismiss()
    }
    
    @IBAction func onValueChanged(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if isStartDate {
            strStart = dateFormatter.stringFromDate(datePicker.date)
            btnStart.setTitle(strStart, forState: .Normal)
        } else {
            strEnd = dateFormatter.stringFromDate(datePicker.date)
            btnEnd.setTitle(strEnd, forState: .Normal)
        }
        
    }
    // MARK: - Internal methods
    internal func _initUI() {
        datePicker.setValue(false, forKey: "highlightsToday")
        btnRepeat.layer.borderWidth = 1.0
        btnRepeat.layer.borderColor = UIColor.whiteColor().CGColor
        btnRepeat.layer.cornerRadius = 8.0
        btnRepeat.layer.masksToBounds = true
        
        btnStart.layer.borderWidth = 1.0
        btnStart.layer.borderColor = UIColor.whiteColor().CGColor
        btnStart.layer.cornerRadius = 8.0
        btnStart.layer.masksToBounds = true
        
        btnEnd.layer.borderWidth = 1.0
        btnEnd.layer.borderColor = UIColor.whiteColor().CGColor
        btnEnd.layer.cornerRadius = 8.0
        btnEnd.layer.masksToBounds = true
        
        if !strStart.isEmpty && !strEnd.isEmpty {
            btnStart.setTitle(strStart, forState: .Normal)
            btnEnd.setTitle(strEnd, forState: .Normal)
        }
        if !strMode.isEmpty {
            self.btnRepeat.setTitle(strMode, forState: .Normal)
        }
        switch strMode {
        case "None":
            repeatDropDown.selectRowAtIndex(0)
            self.btnStart.enabled = false
            self.btnEnd.enabled = false
            self.btnStart.setTitle("", forState: .Normal)
            self.btnEnd.setTitle("", forState: .Normal)
            self._hideDatePicker()
            break
        case "Daily":
            repeatDropDown.selectRowAtIndex(1)
            break
        case "Weekly":
            repeatDropDown.selectRowAtIndex(2)
            break
        case "Monthly":
            repeatDropDown.selectRowAtIndex(3)
            break
        default:
            repeatDropDown.selectRowAtIndex(0)
            self.btnStart.enabled = false
            self.btnEnd.enabled = false
            self._hideDatePicker()
            break
        }
    }
    internal func _hideDatePicker() {
        datePicker.hidden = true
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
