//
//  DutyReport+CoreDataProperties.swift
//  EpidemicReporting
//
//  Created by IBM on 03/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
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
    @NSManaged public var processTime: NSDate?
    @NSManaged public var reportDescription: String?
    @NSManaged public var reporter: String?
    @NSManaged public var reporterName: String?
    @NSManaged public var reportTime: NSDate?

}
