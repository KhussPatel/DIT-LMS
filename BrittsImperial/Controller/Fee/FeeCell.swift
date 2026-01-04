//
//  FeeCell.swift
//  BrittsImperial
//
//  Created by Khuss on 27/10/23.
//

import Foundation
import UIKit

class FeeCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblRemain: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class FeeHistoryCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbldata: UILabel!
    @IBOutlet weak var lblReceiveAmt: UILabel!
    @IBOutlet weak var lblUSD: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblCollectBy: UILabel!
    @IBOutlet weak var btnFileDownload: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
