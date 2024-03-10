//
//  Location+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var country: String?
    @NSManaged public var lat: NSDecimalNumber?
    @NSManaged public var localtime: String?
    @NSManaged public var localtimeEpoch: Int64
    @NSManaged public var lon: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var tzId: String?
    @NSManaged public var forecastCore: ForecastCore?

}

extension Location : Identifiable {

}
