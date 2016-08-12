//
//  SpaSettingComponentCell.swift
//  OwnerApp
//
//  Created by Star Developer on 5/25/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

protocol SpaSettingComponentCellDelegate {
    func didChangedComponentState(cell: SpaSettingComponentCell)
}

class SpaSettingComponentCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    var statusIndex = 1
    
    var deviceNumber: Int = 0
    var value: ControlState = .OFF
    var name: String = ""
    var componentType: String = ""
    var availableValues = [String]()
    var iValues = [Int]()
    var delegate: SpaSettingComponentCellDelegate?
    
    let arrStatus = ["OnSelected", "OffSelected", "LowSelected", "MedSelected", "HiSelected"]
    let arrValues = ["ON", "OFF", "LOW", "MED", "HIGH"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Click event
    @IBAction func onClickMinus(sender: AnyObject) {
        if availableValues.count == 0 {
            print("Warning: availableValues is empty.")
            return
        }
        statusIndex -= 1
        if statusIndex < 0 {
            statusIndex += iValues.count
        }

        imgStatus.image = UIImage(named: arrStatus[iValues[statusIndex]])
        value = ControlState(rawValue: arrValues[iValues[statusIndex]])!
        self.delegate?.didChangedComponentState(self)
    }
    
    @IBAction func onClickPlus(sender: AnyObject) {
        if availableValues.count == 0 {
            print("Warning: availableValues is empty.")
            return
        }
        statusIndex += 1
        if statusIndex >= iValues.count {
            statusIndex -= iValues.count
        }

        imgStatus.image = UIImage(named: arrStatus[iValues[statusIndex]])
        value = ControlState(rawValue: arrValues[iValues[statusIndex]])!
        self.delegate?.didChangedComponentState(self)
    }

    // MARK: - Internal func
    internal func initUI() {
        viewBackground.layer.cornerRadius = 10.0
        viewBackground.layer.masksToBounds = true
        if name.isEmpty {
            print("Warning: name is empty.")
            lblName.text = componentType
        } else {
            lblName.text = name
        }
        //Generate iValues array
        for val in availableValues {
            switch val {
            case "ON":
                iValues.append(0)
                break
            case "OFF":
                iValues.append(1)
                break
            case "LOW":
                iValues.append(2)
                break
            case "MED":
                iValues.append(3)
                break
            case "HIGH",
                 "HI":
                iValues.append(4)
                break
            default:
                break
            }
        }
        if availableValues.count != 0 {
            statusIndex = availableValues.indexOf(self.value.rawValue)!
            imgStatus.image = UIImage(named: arrStatus[iValues[statusIndex]])
        }
    }
}
