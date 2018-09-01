//
//  UIView+Ext.swift
//  OnlinePlanting
//
//  Created by ___Alex___ on 5/1/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func startLoadingAnimation(_ isShow: Bool) {
        if isShow {
            let animationFull : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            animationFull.fromValue     = 0
            animationFull.toValue       = 2*Double.pi
            animationFull.duration      = 1
            animationFull.repeatCount   = Float.infinity
            layer.add(animationFull, forKey: "rotation")
        } else {
            layer.removeAllAnimations()
        }
    }
    
    var screenshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        if let tableView = self as? UITableView {
            tableView.superview!.layer.render(in: UIGraphicsGetCurrentContext()!)
        } else {
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    func addScaleAnimation() {
        let keyAnimate = CAKeyframeAnimation(keyPath: "transform.scale")
        
        keyAnimate.values = [0.8, 1, 1.1];
        keyAnimate.isRemovedOnCompletion = true
        keyAnimate.fillMode = kCAFillModeForwards
        keyAnimate.duration = 0.1
        keyAnimate.repeatCount = 2
        layer.add(keyAnimate, forKey: "scale")
    }

}
