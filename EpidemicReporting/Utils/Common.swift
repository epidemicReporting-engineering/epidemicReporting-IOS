//
//  Common.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/12.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import UIKit
import Photos

let themeBlue = "#1296db"

enum DutyStatus: String {
    case UNASSIGN = "0"
    case ASSIGNED = "1"
    case START = "2"
    case BLOCK = "3"
    case FINISH = "4"
    case SUCCESS = "5"
    case CANTDO = "6"
    case ALL = "7"
}

enum PullDataType: String {
    case LOAD = "load"
    case REFRESH = "refresh"
}

enum FileUploadErrorCode: Int {
    case UPLOADING = 0
    case UPLOADFAILED = 1
}



