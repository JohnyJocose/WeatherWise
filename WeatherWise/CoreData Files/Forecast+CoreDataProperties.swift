//
//  Forecast+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var forecastCore: ForecastCore?
    @NSManaged public var forecastDay: NSOrderedSet?

}

// MARK: Generated accessors for forecastDay
extension Forecast {

    @objc(insertObject:inForecastDayAtIndex:)
    @NSManaged public func insertIntoForecastDay(_ value: ForecastDay, at idx: Int)

    @objc(removeObjectFromForecastDayAtIndex:)
    @NSManaged public func removeFromForecastDay(at idx: Int)

    @objc(insertForecastDay:atIndexes:)
    @NSManaged public func insertIntoForecastDay(_ values: [ForecastDay], at indexes: NSIndexSet)

    @objc(removeForecastDayAtIndexes:)
    @NSManaged public func removeFromForecastDay(at indexes: NSIndexSet)

    @objc(replaceObjectInForecastDayAtIndex:withObject:)
    @NSManaged public func replaceForecastDay(at idx: Int, with value: ForecastDay)

    @objc(replaceForecastDayAtIndexes:withForecastDay:)
    @NSManaged public func replaceForecastDay(at indexes: NSIndexSet, with values: [ForecastDay])

    @objc(addForecastDayObject:)
    @NSManaged public func addToForecastDay(_ value: ForecastDay)

    @objc(removeForecastDayObject:)
    @NSManaged public func removeFromForecastDay(_ value: ForecastDay)

    @objc(addForecastDay:)
    @NSManaged public func addToForecastDay(_ values: NSOrderedSet)

    @objc(removeForecastDay:)
    @NSManaged public func removeFromForecastDay(_ values: NSOrderedSet)

}

extension Forecast : Identifiable {

}
