//
//  PHAsset+Ext.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/27.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}
