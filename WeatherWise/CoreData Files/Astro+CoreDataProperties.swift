//
//  Astro+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension Astro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Astro> {
        return NSFetchRequest<Astro>(entityName: "Astro")
    }

    @NSManaged public var moonIllumination: NSDecimalNumber?
    @NSManaged public var moonPhase: String?
    @NSManaged public var moonrise: String?
    @NSManaged public var moonset: String?
    @NSManaged public var sunrise: String?
    @NSManaged public var sunset: String?
    @NSManaged public var forecastDay: ForecastDay?

}

extension Astro : Identifiable {

}
