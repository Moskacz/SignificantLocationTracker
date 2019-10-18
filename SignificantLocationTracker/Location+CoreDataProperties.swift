//
//  Location+CoreDataProperties.swift
//  SignificantLocationTracker
//
//  Created by Michal Moskala on 18/10/2019.
//  Copyright © 2019 Michal Moskala. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date!

}
