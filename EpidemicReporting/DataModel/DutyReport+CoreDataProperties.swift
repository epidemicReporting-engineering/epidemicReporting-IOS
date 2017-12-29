//
//  DutyReport+CoreDataProperties.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/28.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//
//

import Foundation
import CoreData


extension DutyReport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DutyReport> {
        return NSFetchRequest<DutyReport>(entityName: "DutyReport")
    }

    @NSManaged public var dutyDescription: String?
    @NSManaged public var dutyMultiMedia: NSData?
    @NSManaged public var dutyOwner: String?
    @NSManaged public var dutyOwnerName: String?
    @NSManaged public var dutyStatus: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: String?
    @NSManaged public var leaderComment: String?
    @NSManaged public var leaderPoint: String?
    @NSManaged public var location: String?
    @NSManaged public var longitude: String?
    @NSManaged public var multiMedia: NSData?
    @NSManaged public var processTime: NSNumber?
    @NSManaged public var reportDescription: String?
    @NSManaged public var reporter: String?
    @NSManaged public var reporterName: String?
    @NSManaged public var reportTime: Int64

}
