//
//  Utils.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation

class Utils {
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func getScreenHeigh() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func getCurrentTimeStamp(_ time: Int64) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        return dateformatter.string(from: date as Date)
    }
    
    class func getDutyStatus(_ status: String) -> String {
        switch status {
        case "0":
            return "未分配"
        case "1":
            return "已分配"
        case "2":
            return "已开始"
        case "3":
            return "有障碍"
        case "4":
            return "已完成"
        case "5":
            return "已评阅"
        case "6":
            return "不能做"
        default:
            return "未分配"
        }
    }
}

