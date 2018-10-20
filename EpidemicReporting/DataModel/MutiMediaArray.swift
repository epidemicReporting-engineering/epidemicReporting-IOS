//
//  MutiMediaArray.swift
//  EpidemicReporting
//
//  Created by Jianyu Wang on 17/10/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class MutiMediaArray: ValueTransformer {

    override class func transformedValueClass() -> Swift.AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value else { return nil }
        return NSKeyedArchiver.archivedData(withRootObject: value)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
}
