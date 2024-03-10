//
//  Current+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Current {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Current> {
        return NSFetchRequest<Current>(entityName: "Current")
    }

    @NSManaged public var cloud: Int64
    @NSManaged public var feelslikeC: NSDecimalNumber?
    @NSManaged public var feelslikeF: NSDecimalNumber?
    @NSManaged public var gustKph: NSDecimalNumber?
    @NSManaged public var gustMph: NSDecimalNumber?
    @NSManaged public var humidity: Int64
    @NSManaged public var isDay: Int64
    @NSManaged public var lastUpdated: String?
    @NSManaged public var lastUpdatedEpoch: Int64
    @NSManaged public var precipIn: NSDecimalNumber?
    @NSManaged public var precipMm: NSDecimalNumber?
    @NSManaged public var pressureIn: NSDecimalNumber?
    @NSManaged public var pressureMb: NSDecimalNumber?
    @NSManaged public var tempC: NSDecimalNumber?
    @NSManaged public var tempF: NSDecimalNumber?
    @NSManaged public var uv: NSDecimalNumber?
    @NSManaged public var windDegree: Int64
    @NSManaged public var windDir: String?
    @NSManaged public var windKph: NSDecimalNumber?
    @NSManaged public var windMph: NSDecimalNumber?
    @NSManaged public var condition: Condition?
    @NSManaged public var forecastCore: ForecastCore?

}

extension Current : Identifiable {

}
