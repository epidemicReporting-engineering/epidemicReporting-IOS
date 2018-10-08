//
//  UnderlineTextfield.swift
//  EpidemicReporting
//
//  Created by WangJianyu on 2018/9/24.
//  Copyright © 2018年 epidemicreporting.com. All rights reserved.
//

import UIKit

class UnderlineTextfield: UITextField {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.gray.cgColor)
        context?.fill(CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1))
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width - 5, height: bounds.height - 5))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width - 5, height: bounds.height - 5))
    }

}
