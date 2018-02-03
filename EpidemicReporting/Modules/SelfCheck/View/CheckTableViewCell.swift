//
//  CheckTableViewCell.swift
//  EpidemicReporting
//
//  Created by IBM on 03/02/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkTime: UILabel!
    @IBOutlet weak var checkLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ name: String?, checkTime: NSDate?, checkLocation: String?) {
        self.name.text = name
        if let date = checkTime {
            self.checkTime.text = "签到时间：" + Utils.getCurrentTimeStamp(date)
        }
        self.checkLocation.text = checkLocation
    }

}
