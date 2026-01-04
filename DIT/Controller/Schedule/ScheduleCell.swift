//
//  ScheduleCell.swift
//  BrittsImperial
//
//  Created by Khuss on 27/09/23.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var lblUnitName: UILabel!
    @IBOutlet weak var lblUnitCode: UILabel!
    
    @IBOutlet weak var btn_VIEW: UIButton!
    @IBOutlet weak var vw_ViewAll: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
