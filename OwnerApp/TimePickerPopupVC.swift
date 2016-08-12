//
//  TimePickerController.swift
//  OwnerApp
//
//  Created by Star Developer on 6/10/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
protocol TimePickerDelegate {
    func didSelectTime(strTime: String)
}
class TimePickerPopupVC: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    var delegate: TimePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(onClickDone))
        self.contentSizeInPopup = CGSizeMake(300, 200);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onClickDone() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let strTime = dateFormatter.stringFromDate(timePicker.date)
        self.delegate?.didSelectTime(strTime)
        self.popupController.dismiss()
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
