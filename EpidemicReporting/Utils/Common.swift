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
