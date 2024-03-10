//
//  ForecastDay+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension ForecastDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastDay> {
        return NSFetchRequest<ForecastDay>(entityName: "ForecastDay")
    }

    @NSManaged public var date: String?
    @NSManaged public var dateEpoch: Int64
    @NSManaged public var astro: Astro?
    @NSManaged public var day: Day?
    @NSManaged public var forecast: Forecast?
    @NSManaged public var hour: NSOrderedSet?

}

// MARK: Generated accessors for hour
extension ForecastDay {

    @objc(insertObject:inHourAtIndex:)
    @NSManaged public func insertIntoHour(_ value: Hour, at idx: Int)

    @objc(removeObjectFromHourAtIndex:)
    @NSManaged public func removeFromHour(at idx: Int)

    @objc(insertHour:atIndexes:)
    @NSManaged public func insertIntoHour(_ values: [Hour], at indexes: NSIndexSet)

    @objc(removeHourAtIndexes:)
    @NSManaged public func removeFromHour(at indexes: NSIndexSet)

    @objc(replaceObjectInHourAtIndex:withObject:)
    @NSManaged public func replaceHour(at idx: Int, with value: Hour)

    @objc(replaceHourAtIndexes:withHour:)
    @NSManaged public func replaceHour(at indexes: NSIndexSet, with values: [Hour])

    @objc(addHourObject:)
    @NSManaged public func addToHour(_ value: Hour)

    @objc(removeHourObject:)
    @NSManaged public func removeFromHour(_ value: Hour)

    @objc(addHour:)
    @NSManaged public func addToHour(_ values: NSOrderedSet)

    @objc(removeHour:)
    @NSManaged public func removeFromHour(_ values: NSOrderedSet)

}

extension ForecastDay : Identifiable {

}
