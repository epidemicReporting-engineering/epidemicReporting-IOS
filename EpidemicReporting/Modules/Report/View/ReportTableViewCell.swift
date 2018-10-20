//
//  ReportTableViewCell.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ReportTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var reporter: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var processor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateDataSource(_ data: JSON?) {
        guard let data = data else { return }
        let reportDateDouble = data["happenTime"].double
        reporter.text = data["reporterName"].string ?? ""
        if let reportDateDouble = reportDateDouble {
            time.text = "\(Utils.getCurrentTimeStamp(NSDate(timeIntervalSince1970: reportDateDouble / 1000)))"
        } else {
            time.text = ""
        }
        
        if let status = data["dutyStatus"].string, status == DutyStatus.UNASSIGN.rawValue {
            content.text = data["description"].string ?? ""
        } else {
            content.text = data["dutyDescription"].string ?? ""
        }
        
        processor.text = "责任人：\(data["dutyOwnerName"].string ?? "未知")"

        if let urlsJson = data["multiMedia"].array {
            if urlsJson.count > 0, let url = urlsJson.first?.string {
                cover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "defaultIcon"))
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
