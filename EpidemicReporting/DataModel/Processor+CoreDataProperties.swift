//
//  Processor+CoreDataProperties.swift
//  EpidemicReporting
//
//  Created by IBM on 06/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//
//

import Foundation
import CoreData


extension Processor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Processor> {
        return NSFetchRequest<Processor>(entityName: "Processor")
    }

    @NSManaged public var username: String?
    @NSManaged public var dutyNums: NSNumber?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var location: String?

}
