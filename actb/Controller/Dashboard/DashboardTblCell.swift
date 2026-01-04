//
//  DashboardTblCell.swift
//  BrittsImperial
//
//  Created by Khuss on 29/06/24.
//

import UIKit

class DashboardTblCell: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(obj:DashboardList){
        
        if let title = obj.name{
            lbltitle.text = title
        }
        
        if let subtitle = obj.unitName{
            lblSubtitle.text = subtitle
        }
        
    }
    
    func setDataAssignemtAndResource(obj:DashboardList){
        
        if let title = obj.name{
            lbltitle.text = title
        }
        
        if let subtitle = obj.unitName{
            lblSubtitle.text = subtitle
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
