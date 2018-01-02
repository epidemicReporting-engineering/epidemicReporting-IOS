//
//  GetCurrentLocationUtils.swift
//  EpidemicReporting
//
//  Created by IBM on 02/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import Foundation


class GetCurrentLocationUtils: NSObject {
    
    lazy var locationManager: AMapLocationManager = {
        return AMapLocationManager()
    }()
    
    static var sharedInstance: GetCurrentLocationUtils {
        struct Static {
            static let instance: GetCurrentLocationUtils = GetCurrentLocationUtils()
        }
        return Static.instance
    }
    
    func getCurrentLocation(handler: @escaping ((_ location: CLLocation?,_ success: Bool, _ error: NSError?)->())) {
        locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    handler(nil,false,error)
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    handler(nil,false,error)
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                    if let location = location {
                        NSLog("location:%@", location)
                        handler(location,true,nil)
                    }
                }
            }
        })
    }
}
