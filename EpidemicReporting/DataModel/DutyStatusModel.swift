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
        let reporterName = data["reporterName"].string ?? ""
        let description = data["description"].string ?? ""

        let status = dutyDetails.map { (statusItemData) -> DutyStatusModel in
            let dutyItem = DutyStatusModel()
            dutyItem.id = statusItemData["dutyId"].int64
            dutyItem.leaderComment = statusItemData["leaderComment"].string ?? ""
            dutyItem.dutyDescription = statusItemData["dutyDescription"].string ?? ""
            dutyItem.dutyMultiMedia = statusItemData.dictionaryObject?["dutyMultiMedia"] as? [String]
            dutyItem.dutyOwnerName = statusItemData["dutyOwnerName"].string ?? ""
            dutyItem.dutyOwner = statusItemData["dutyOwner"].string ?? ""
            dutyItem.leaderPoint = statusItemData["leaderPoint"].string
            dutyItem.dutyStatus = statusItemData["dutyStatus"].string ?? "0"
            dutyItem.reportDescription = description
            dutyItem.reporterName = reporterName
            return dutyItem
        }
        return status
    }
    
    public func getDutyStatus() ->[DutyStatusModel]? {
        return statsData
    }
}

