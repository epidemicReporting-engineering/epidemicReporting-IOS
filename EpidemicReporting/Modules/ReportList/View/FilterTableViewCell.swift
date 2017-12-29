//
//  FilterTableViewCell.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/28.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var number: UILabel!
    
    var dutyStatus: DutyStatus?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updataSouce(_ image: UIImage?, content: String?, status: DutyStatus?, count: String?) {
        guard let indicator = image, let contentType = content, let saveStatus = status, let numbers = count else { return }
        logo.image = indicator
        type.text = contentType
        dutyStatus = saveStatus
        number.text = "(" + numbers + ")"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
