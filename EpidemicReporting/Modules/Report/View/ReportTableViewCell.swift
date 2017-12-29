//
//  ReportTableViewCell.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import SDWebImage

class ReportTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var reporter: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var processor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = statusView.bounds.width / 2
        statusView.layer.masksToBounds = true
    }
    
    func updateDataSource(_ cell: DutyReport?) {
        guard let report = cell else { return }
        reporter.text = report.reporterName
        time.text = Utils.getCurrentTimeStamp(report.reportTime)
        content.text = report.dutyDescription
        if let reportStatus = report.dutyStatus {
            status.text = Utils.getDutyStatus(reportStatus)
        }
        
        if let dutyOwner = report.dutyOwnerName {
            processor.text = "责任人：" + dutyOwner
        }
        
        if let media = report.multiMedia {
            let medias = NSKeyedUnarchiver.unarchiveObject(with: media as Data) as? [String]
            if let urls = medias, urls.count > 0, let url = urls.first {
                cover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "defaultIcon"))
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
