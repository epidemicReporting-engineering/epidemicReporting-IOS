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
    @IBOutlet weak var location: UILabel!
    
    var processor: Processor?
    var processorHandler:((_ processor: Processor?)->())?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        if let name = processor?.username {
            username.text = "处理人员：" + name
        }
        
        if let address = processor?.location {
            location.text = "地址：" + address
        } else {
            location.text = "地址不明确"
        }
        
        if let number = processor?.dutyNums {
            task.text = "当前任务（\(number)）"
        }
    }
    
    @IBAction func showAlter(_ sender: UITapGestureRecognizer) {

    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let point = self.convert(point, to: self)
        if self.point(inside: point, with: event) {
            print("inside the view")
            guard let currentProcessor = processor else { return nil}
            processorHandler?(currentProcessor)
            return UIView()
        } else {
            return super.hitTest(point, with: event)
        }
        return nil
    }
}
