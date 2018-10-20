//
//  MyMessageTableViewCell.swift
//  EpidemicReporting
//
//  Created by IBM on 02/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var reporter: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var statusDescription: UILabel!
    @IBOutlet weak var currentOwner: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        statusImage.layer.cornerRadius = statusImage.bounds.width / 2
        statusImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ cell: DutyReport?) {
        guard let report = cell, let status = report.dutyStatus, let name = report.reporterName else { return }
        reporter.text = "疫情上报者：" + name
        if status == DutyStatus.UNASSIGN.rawValue {
            lastMessage.text = report.reportDescription
        } else {
            lastMessage.text = report.dutyDescription
        }
        if let owner = report.dutyOwnerName {
            currentOwner.text = "当前责任人：" + owner
        }
        updateImage(status)
    }
    
    func updateDataSource(data: JSON?) {
        guard let data = data, let status = data["dutyStatus"].string else { return }
        reporter.text = "疫情上报者：" + (data["reporterName"].string ?? "")
        if status == DutyStatus.UNASSIGN.rawValue {
            lastMessage.text = data["description"].string
        } else {
            lastMessage.text = data["dutyDescription"].string
        }
        if let owner = data["dutyOwnerName"].string {
            currentOwner.text = "当前责任人：" + owner
        }
        
        updateImage(status)

    }
    
    func updateImage(_ status: String) {
        switch status {
        case DutyStatus.UNASSIGN.rawValue:
            //statusImage.image = UIImage.init(named: "unknow")
            statusImage.backgroundColor = UIColor.init(hexString: themeBlue)
            statusDescription.text = "未分配"
            statusDescription.textColor = UIColor.white
        case DutyStatus.ASSIGNED.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: themeBlue)
            statusDescription.text = "新任务"
            statusDescription.textColor = UIColor.white
        case DutyStatus.START.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: "#66CCCC")
            statusDescription.text = "开始处理"
            statusDescription.textColor = UIColor.white
        case DutyStatus.BLOCK.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: blockRed)
            statusDescription.text = "有困难"
            statusDescription.textColor = UIColor.white
        case DutyStatus.FINISH.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: "#336699")
            statusDescription.text = "等待审阅"
            statusDescription.textColor = UIColor.white
        case DutyStatus.SUCCESS.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: finishGreen)
            statusDescription.text = "完成"
            statusDescription.textColor = UIColor.white
        case DutyStatus.CANTDO.rawValue:
            statusImage.backgroundColor = UIColor.init(hexString: "#666666")
            statusDescription.text = "无法做"
            statusDescription.textColor = UIColor.white
        default:
            statusImage.backgroundColor = UIColor.init(hexString: themeBlue)
            statusDescription.text = "未分配"
            statusDescription.textColor = UIColor.white
        }
    }
    
    
}
