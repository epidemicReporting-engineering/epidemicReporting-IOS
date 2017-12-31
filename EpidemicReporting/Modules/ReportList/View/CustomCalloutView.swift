//
//  CustomAnnotationView.swift
//  EpidemicReporting
//
//  Created by IBM on 31/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        layer.shadowColor = UIColor.black.cgColor as! CGColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundColor = UIColor.darkGray
    }
    
    func updateSource(_ usernameIn: String?, taskNum: String?) {
        username.text = usernameIn
        task.text = taskNum
    }
}
