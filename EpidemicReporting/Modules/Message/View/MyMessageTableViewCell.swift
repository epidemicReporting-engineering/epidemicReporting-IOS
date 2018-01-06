//
//  MyMessageTableViewCell.swift
//  EpidemicReporting
//
//  Created by IBM on 02/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var reporter: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ cell: DutyReport?) {
        guard let report = cell, let status = report.dutyStatus, let name = report.reporterName else { return }
        reporter.text = "疫情上报者：" + name
        lastMessage.text = report.dutyDescription
        updateImage(status)
    }
    
    func updateImage(_ status: String) {
        switch status {
        case DutyStatus.UNASSIGN.rawValue:
            statusImage.image = UIImage.init(named: "unknow")
        case DutyStatus.ASSIGNED.rawValue:
            statusImage.image = UIImage.init(named: "new_task")
        case DutyStatus.START.rawValue:
            statusImage.image = UIImage.init(named: "start")
        case DutyStatus.BLOCK.rawValue:
            statusImage.image = UIImage.init(named: "block")
        case DutyStatus.FINISH.rawValue:
            statusImage.image = UIImage.init(named: "success")
        case DutyStatus.SUCCESS.rawValue:
            statusImage.image = UIImage.init(named: "confirm")
        case DutyStatus.CANTDO.rawValue:
            statusImage.image = UIImage.init(named: "cantdo")
        default:
            statusImage.image = UIImage.init(named: "circle_blue")
        }
    }
    
    
}
