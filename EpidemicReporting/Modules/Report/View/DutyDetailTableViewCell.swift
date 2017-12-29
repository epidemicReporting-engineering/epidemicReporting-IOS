//
//  DutyDetailTableViewCell.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/29.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit

class DutyDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var dutyDescription: UILabel!
    @IBOutlet weak var reporter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateDataSource(_ data: DutyStatusModel?, isFirst: Bool, isLast: Bool) {
        if let model = data, let status = model.dutyStatus {
            updateImage(status, isFirst: isFirst, isLast: isLast)
            
            if isFirst {
                dutyDescription.text = model.reportDescription
            } else {
                dutyDescription.text = model.dutyDescription
            }
            
            
            if status == DutyStatus.UNASSIGN.rawValue {
                guard let report = data?.reporterName else { return }
                reporter.text = "疫情上报人：" + report
            } else {
                guard let owner = data?.dutyOwnerName  else { return }
                reporter.text = "处理人：" + owner
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateImage(_ status: String, isFirst: Bool, isLast: Bool) {
        if isLast {
            downView.isHidden = true
        }
        switch status {
        case DutyStatus.UNASSIGN.rawValue:
            statusImage.image = UIImage.init(named: "circle_unassigned")
            
        case DutyStatus.BLOCK.rawValue:
            statusImage.image = UIImage.init(named: "circle_red")
        case DutyStatus.SUCCESS.rawValue:
            statusImage.image = UIImage.init(named: "success")
        default:
            statusImage.image = UIImage.init(named: "circle_blue")
        }
    }

}
