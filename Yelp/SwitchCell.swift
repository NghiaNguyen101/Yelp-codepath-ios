//
//  SwitchCell.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/13/17.
//  Copyright (c) 2017 Timothy Lee, Nghia Nguyen. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: "switchValueChange", for: .valueChanged)
    }
    
    func switchValueChange() {
        print("Switch Value Change")
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
