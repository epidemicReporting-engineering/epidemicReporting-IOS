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

func getUIImageFromAsset(_ asset: PHAsset) -> UIImage? {
    var img: UIImage?
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.version = .original
    options.isSynchronous = true
    manager.requestImageData(for: asset, options: options) { data, _, _, _ in
        if let data = data {
            img = UIImage(data: data)
        }
    }
    return img
}



enum DutyStatus: String {
    case UNASSIGN = "0"
    case ASSIGNED = "1"
    case START = "2"
    case BLOCK = "3"
    case FINISH = "4"
    case SUCCESS = "5"
    case CANTDO = "6"
}

enum PullDataType: String {
    case LOAD = "load"
    case REFRESH = "refresh"
}



