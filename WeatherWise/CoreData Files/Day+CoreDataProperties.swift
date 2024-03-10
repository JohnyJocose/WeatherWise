//
//  Day+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var avghumidity: Int64
    @NSManaged public var avgtempC: NSDecimalNumber?
    @NSManaged public var avgtempF: NSDecimalNumber?
    @NSManaged public var avgvisKm: NSDecimalNumber?
    @NSManaged public var avgvisMiles: NSDecimalNumber?
    @NSManaged public var maxtempC: NSDecimalNumber?
    @NSManaged public var maxtempF: NSDecimalNumber?
    @NSManaged public var maxwindKph: NSDecimalNumber?
    @NSManaged public var maxwindMph: NSDecimalNumber?
    @NSManaged public var mintempC: NSDecimalNumber?
    @NSManaged public var mintempF: NSDecimalNumber?
    @NSManaged public var totalprecipIn: NSDecimalNumber?
    @NSManaged public var totalprecipMm: NSDecimalNumber?
    @NSManaged public var uv: NSDecimalNumber?
    @NSManaged public var condition: Condition?
    @NSManaged public var forecastDay: ForecastDay?

}

extension Day : Identifiable {

}
