//
//  User+CoreDataProperties.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var refreshToken: String?
    @NSManaged public var userid: String?

}
