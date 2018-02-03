//
//  Check+CoreDataProperties.swift
//  EpidemicReporting
//
//  Created by IBM on 03/02/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//
//

import Foundation
import CoreData


extension Check {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var username: String?
    @NSManaged public var location: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var isAbsence: NSNumber?
    @NSManaged public var isAvailable: NSNumber?
    @NSManaged public var createTime: NSDate?

}
