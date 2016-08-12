//
//  SpaSettingTemperatureCell.swift
//  OwnerApp
//
//  Created by Star Developer on 5/25/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

protocol SpaSettingTemperatureCellDelegate {
    func didChangedTemperature(temperature: Int)
}

class SpaSettingTemperatureCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var viewBackground: UIView!

    var temperature: Int = 50
    var name: String = "Temperature"
    var delegate: SpaSettingTemperatureCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Click event
    
    @IBAction func onClickMinus(sender: AnyObject) {
        temperature -= 1
        lblTemperature.text = String.localizedStringWithFormat("%d°", temperature)
        delegate?.didChangedTemperature(temperature)
    }
    
    @IBAction func onClickPlus(sender: AnyObject) {
        temperature += 1
        lblTemperature.text = String.localizedStringWithFormat("%d°", temperature)
        delegate?.didChangedTemperature(temperature)
    }
    
    // MARK: - Internal func
    internal func initUI() {
        viewBackground.layer.cornerRadius = 10.0
        viewBackground.layer.masksToBounds = true
        lblName.text = name
        lblTemperature.text = String.localizedStringWithFormat("%d°", temperature)
    }
}
