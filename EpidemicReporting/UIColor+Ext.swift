//
//  UIColor+Ext.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import Regex

extension UIColor {
    // hexString must start with '#'
    convenience init(hexString: String) {
        //println("calculating color with hex \(hexString)");
        
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#") {
            let index = hexString.index(hexString.startIndex, offsetBy: 1) // advancedBy(hexString.startIndex, 1)
            let hex = hexString[index..<hexString.endIndex]
            let scanner = Scanner(string: String(hex))
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                if hex.count == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.count == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid hex color string, length should be 7 or 9", terminator: "")
                }
            } else {
                print("scan hex error")
            }
        } else {
            print("invalid hex color string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func getColor(_ colorString: String) -> UIColor? {
        var color: UIColor?
        let regex = Regex.init("(#[0-9a-f]{8}|transparent)", options: [Options.ignoreCase])
        let m = regex.allMatches(in: colorString)
        
        if m.count == 1 {
            if let tmpColor = m[0].captures[0] {
                if "transparent" == tmpColor {
                    color = UIColor.clear
                } else {
                    color = UIColor(hexString: tmpColor)
                }
            }
        }
        
        return color
    }
}
