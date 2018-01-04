//
//  DutyStatusImageCollectionViewCell.swift
//  EpidemicReporting
//
//  Created by IBM on 04/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class DutyStatusImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateDataSource(_ url: String?) {
        guard let media = url else { return }
        albumImage.sd_setImage(with: URL(string: media), placeholderImage: UIImage(named: "defaultIcon"))
    }
}
