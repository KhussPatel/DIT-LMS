//
//  UnitListCell.swift
//  BrittsImperial
//
//  Created by Khuss on 21/10/23.
//

import UIKit

class UnitListCell: UITableViewCell {

    @IBOutlet weak var lblUnitName: UILabel!
    @IBOutlet weak var lblUnitNumber: UILabel!
    @IBOutlet weak var lblUnitCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
