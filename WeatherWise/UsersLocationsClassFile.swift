//
//  UsersLocationsClassFile.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/15/23.
//

import UIKit

public class UsersWeatherLocations {
    var locationsForecastArray: [ForecastStruct] = []
    
    var noLocationEnabledArray: [ForecastStruct] = []
    var yesLocationEnabledArray: [ForecastStruct] = []
    
    var usersLocation: ForecastStruct!
    var locationEnabled: Bool!
    var firstTimeBoot = true
    
    func addLocation(location: ForecastStruct) {
        locationsForecastArray.append(location)
    }
    
    func deleteLocation(at index: Int) {
        locationsForecastArray.remove(at: index)
    }
    
    func removeLocation(at index: Int) -> ForecastStruct {
        return locationsForecastArray.remove(at: index)
    }
    
    func insertRemovedLocation(removedLocation: ForecastStruct, at index: Int) {
        locationsForecastArray.insert(removedLocation, at: index)
    }
    
    func returnUsersLocationsCount() -> Int {
        return locationsForecastArray.count
    }
    
    func isUsersLocationsEmpty() -> Bool {
        return locationsForecastArray.isEmpty
    }
    
    func isLocationEnabled() -> Bool {
        guard let locationEnabled else {return false}
        if locationEnabled{
            return true
        }
        return false
    }
    
    func isFirstTimeBootingApp() -> Bool {
        return firstTimeBoot
    }
    
    func changeFirstTimeBootStatus() {
        firstTimeBoot = false
    }
    
    
    
    
    
    
    
    
    
    func returnLocationNameForMainVC(at index: Int) -> String {
        if index == 0 {
            return "My Location\n\(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
        }
        return "\(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
    }
    
    func returnLocationNameForLocationVC(at index: Int) -> String {
        if index == 0 {
            return "My Location - \(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
        }
        return "\(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
    }
    
    func debugPrintLocationArray() {
        print("THIS IS FOR DEBUG PURPOSES!")
        print(locationsForecastArray)
    }
    
    func debugPrintLocationArrayCount() {
        print("THIS IS FOR DEBUG PURPOSES!")
        print(locationsForecastArray.count)
    }
}

public let usersInfo = UsersWeatherLocations()
