//
//  Condition+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Condition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Condition> {
        return NSFetchRequest<Condition>(entityName: "Condition")
    }

    @NSManaged public var code: Int64
    @NSManaged public var icon: String?
    @NSManaged public var text: String?
    @NSManaged public var current: Current?
    @NSManaged public var day: Day?
    @NSManaged public var hour: Hour?

}

extension Condition : Identifiable {

}
