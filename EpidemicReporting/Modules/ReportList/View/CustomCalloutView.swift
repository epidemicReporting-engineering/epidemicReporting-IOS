//
//  CustomAnnotationView.swift
//  EpidemicReporting
//
//  Created by IBM on 31/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var task: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
