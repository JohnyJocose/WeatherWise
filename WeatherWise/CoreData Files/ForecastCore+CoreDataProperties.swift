//
//  ForecastCore+CoreDataProperties.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData


extension ForecastCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastCore> {
        return NSFetchRequest<ForecastCore>(entityName: "ForecastCore")
    }

    @NSManaged public var current: Current?
    @NSManaged public var forecast: Forecast?
    @NSManaged public var location: Location?

}

extension ForecastCore : Identifiable {

}
