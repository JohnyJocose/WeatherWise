//
//  Hour+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Hour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hour> {
        return NSFetchRequest<Hour>(entityName: "Hour")
    }

    @NSManaged public var chanceOfRain: Int64
    @NSManaged public var chanceOfSnow: Int64
    @NSManaged public var cloud: Int64
    @NSManaged public var dewpointC: NSDecimalNumber?
    @NSManaged public var dewpointF: NSDecimalNumber?
    @NSManaged public var feelslikeC: NSDecimalNumber?
    @NSManaged public var feelslikeF: NSDecimalNumber?
    @NSManaged public var gustKph: NSDecimalNumber?
    @NSManaged public var gustMph: NSDecimalNumber?
    @NSManaged public var heatindexC: NSDecimalNumber?
    @NSManaged public var heatindexF: NSDecimalNumber?
    @NSManaged public var humidity: Int64
    @NSManaged public var isDay: Int64
    @NSManaged public var precipIn: NSDecimalNumber?
    @NSManaged public var precipMm: NSDecimalNumber?
    @NSManaged public var pressureIn: NSDecimalNumber?
    @NSManaged public var pressureMb: NSDecimalNumber?
    @NSManaged public var tempC: NSDecimalNumber?
    @NSManaged public var tempF: NSDecimalNumber?
    @NSManaged public var time: String?
    @NSManaged public var timeEpoch: Int64
    @NSManaged public var uv: NSDecimalNumber?
    @NSManaged public var visKm: NSDecimalNumber?
    @NSManaged public var visMiles: NSDecimalNumber?
    @NSManaged public var willItRain: Int64
    @NSManaged public var willItSnow: Int64
    @NSManaged public var windchillC: NSDecimalNumber?
    @NSManaged public var windchillF: NSDecimalNumber?
    @NSManaged public var windDegree: Int64
    @NSManaged public var windDir: String?
    @NSManaged public var windKph: NSDecimalNumber?
    @NSManaged public var windMph: NSDecimalNumber?
    @NSManaged public var condition: Condition?
    @NSManaged public var forecastDay: ForecastDay?

}

extension Hour : Identifiable {

}
