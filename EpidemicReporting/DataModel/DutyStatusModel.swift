//
//  DutyStatusModel.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/29.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class DutyStatusModel {
    
    var id: Int64?
    var dutyOwner: String?
    var leaderPoint: String?
    var leaderComment: String?
    var dutyDescription: String?
    var dutyStatus: String?
    var longitude: String?
    var dutyMultiMedia: [String]?
    var latitude: String?
    var reportTime: Int64?
    var location: String?
    var reportDescription: String?
    var reporter: String?
    var dutyOwnerName: String?
    var processTime: Int64?
    var reporterName: String?
    var multiMedia: [String]?
}

class DutyStatusDataSource {
    
    fileprivate var statsData: [DutyStatusModel]?
    
    init(statusData: JSON?) {
        statsData = parse(statusData)
    }

    fileprivate func parse(_ statusData: JSON?) -> [DutyStatusModel]? {
        guard let data = statusData else { return nil }
        guard let dutyDetails = data["dutyProcessRes"].array else { return nil }
        let reporterName = data["reporterName"].string ?? "信息丢失或空缺"
        let description = data["description"].string ?? "信息丢失或空缺"

        let status = dutyDetails.map { (statusItemData) -> DutyStatusModel in
            let dutyItem = DutyStatusModel()
            dutyItem.id = statusItemData["dutyId"].int64
            dutyItem.leaderComment = statusItemData["leaderComment"].string ?? "信息丢失或空缺"
            dutyItem.dutyDescription = statusItemData["dutyDescription"].string ?? "信息丢失或空缺"
            dutyItem.dutyMultiMedia = statusItemData.dictionaryObject?["dutyMultiMedia"] as? [String]
            dutyItem.dutyOwnerName = statusItemData["dutyOwnerName"].string ?? "信息丢失或空缺"
            dutyItem.dutyOwner = statusItemData["dutyOwner"].string ?? "信息丢失或空缺"
            dutyItem.leaderPoint = statusItemData["leaderPoint"].string
            dutyItem.dutyStatus = statusItemData["dutyStatus"].string ?? "0"
            dutyItem.reportDescription = description
            dutyItem.reporterName = reporterName
//            dutyItem.id = statusItemData.dictionaryObject?["id"] as? Int64
//            dutyItem.dutyOwner = statusItemData.dictionaryObject?["dutyOwner"] as? String
//            dutyItem.leaderPoint = statusItemData.dictionaryObject?["leaderPoint"] as? String
//            dutyItem.leaderComment = statusItemData.dictionaryObject?["leaderComment"] as? String
//            dutyItem.dutyDescription = statusItemData.dictionaryObject?["dutyDescription"] as? String
//            dutyItem.dutyStatus = statusItemData.dictionaryObject?["dutyStatus"] as? String
//            dutyItem.longitude = statusItemData.dictionaryObject?["longitude"] as? String
//            dutyItem.dutyMultiMedia = statusItemData.dictionaryObject?["dutyMultiMedia"] as? [String]
//            dutyItem.latitude = statusItemData.dictionaryObject?["latitude"] as? String
//            dutyItem.reportTime = statusItemData.dictionaryObject?["reportTime"] as? Int64
//            dutyItem.location = statusItemData.dictionaryObject?["location"] as? String
//            dutyItem.reportDescription = statusItemData.dictionaryObject?["reportDescription"] as? String
//            dutyItem.reporter = statusItemData.dictionaryObject?["reporter"] as? String
//            dutyItem.dutyOwnerName = statusItemData.dictionaryObject?["dutyOwnerName"] as? String
//            dutyItem.processTime = statusItemData.dictionaryObject?["processTime"] as? Int64
//            dutyItem.reporterName = statusItemData.dictionaryObject?["reporterName"] as? String
//            dutyItem.multiMedia = statusItemData.dictionaryObject?["multiMedia"] as? [String]
            return dutyItem
        }
        return status
    }
    
    public func getDutyStatus() ->[DutyStatusModel]? {
        return statsData
    }
}

