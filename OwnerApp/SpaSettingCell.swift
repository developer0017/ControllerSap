//
//  SpaSettingCell.swift
//  OwnerApp
//
//  Created by Star Developer on 5/23/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import DLRadioButton

protocol SpaSettingCellDelegate {
    func onClickCalendar(cell: SpaSettingCell)
    func onClickEdit(cell: SpaSettingCell)
    func onClickDelete(cell: SpaSettingCell)
}

class SpaSettingCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnRun: UIButton!
    
    @IBOutlet weak var viewBackground: UIView!
    
    
    var delegate: SpaSettingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackground.layer.cornerRadius = 10.0
        viewBackground.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Click Events Handler
    
    @IBAction func onClickCalendar(sender: AnyObject) {
        delegate?.onClickCalendar(self)
    }
    @IBAction func onClickEdit(sender: AnyObject) {
        delegate?.onClickEdit(self)
    }
    @IBAction func onClickDelete(sender: AnyObject) {
        delegate?.onClickDelete(self)
    }
}
