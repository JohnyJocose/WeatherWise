//
//  UsersLocationsClassFile.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/15/23.
//

import UIKit
import CoreLocation
import Foundation

public class UsersWeatherLocations: NSObject {
    
    
    let locationManager = CLLocationManager()
    
    
    
    
    
    

    var locationsForecastArray: [ForecastStruct] = []
    var forecastWeatherPages: [WeatherView] = [WeatherView()]
    
    //var noLocationEnabledArray: [ForecastStruct] = []
    //var yesLocationEnabledArray: [ForecastStruct] = []
    
    var hourlyForecastData: [[HourResult]] = []
    var threeDayForecastData: [[ForecastDayResult]] = []
    
    
    
    
    var usersLocation: ForecastStruct?
    var locationEnabled: Bool?
    
    
    init(locationEnabled: Bool?) {
        self.locationEnabled = locationEnabled
        configureUsersData()
        
        
    }
    
    func configureUsersData() {
        // If nil then it's the first time booting and we need account for that
        if locationEnabled == nil {
            
        }
        else if locationEnabled == true {
            
        }
        else if locationEnabled == false {
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
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
    
    func isLocationEnabled() -> Bool? {
        guard let locationEnabled else {return nil}
        if locationEnabled{
            return true
        }
        return false
    }
    
    func isFirstTimeBootingApp() -> Bool {
        if locationEnabled == nil {
            return true
        }
        return false
    }

    
//    func addUsersLocationAsFirstArray(lat: Decimal, lon: Decimal){
//        Task {
//            var result = try await forecastJson.getForecastDataAsync(lat: lat, lon: lon)
//            locationsForecastArray.insert(result, at: 0)
//            print(locationsForecastArray)
//        }
//        
//        
//        
//    }
    
    
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
    
    
    
    // MARK: CoreData/API Functions
    func updateAllWeatherViews() {
        for i in 0..<usersInfo.returnUsersLocationsCount(){
            updateWeatherViewInfo(weatherView: forecastWeatherPages[i], forecastInfo: usersInfo.locationsForecastArray[i], index: i)
        }
    }
    
    func updateWeatherViewInfo(weatherView: WeatherView, forecastInfo: ForecastStruct, index: Int) {
        
        populateHourlyForecastData(forecastInfo: forecastInfo, index: index)
        
        populateThreeDayForecastData(forecastInfo: forecastInfo, index: index)
        
        
        var tempDecimal: Decimal = forecastInfo.current.tempF
        var tempDrounded: Decimal = Decimal()
        NSDecimalRound(&tempDrounded, &tempDecimal, 0, .plain)
        let tempString = "\(tempDrounded)°"
        
        var lowDecimal: Decimal = forecastInfo.forecast.forecastday[0].day.mintempF
        var lowDrounded: Decimal = Decimal()
        NSDecimalRound(&lowDrounded, &lowDecimal, 0, .plain)
        let lowString = "L:\(lowDrounded)°  "
        
        var highDecimal: Decimal = forecastInfo.forecast.forecastday[0].day.maxtempF
        var highDrounded: Decimal = Decimal()
        NSDecimalRound(&highDrounded, &highDecimal, 0, .plain)
        let highString = "H:\(highDrounded)°"
        
        let highLowString = lowString + highString
        
        weatherView.updateStackLabels(location: "\(forecastInfo.location.name), \(forecastInfo.location.region)", temperature: tempString, weather: forecastInfo.current.condition.text, highLow: highLowString)
        
        
        
        weatherView.updateHourData(hourForecast: hourlyForecastData[index])
        weatherView.updateThreeDayHourData(threeDayForecast: threeDayForecastData[index])
        weatherView.updateHumidty(humidity: forecastInfo.current.humidity)
        weatherView.updateFeelsLike(feelsLike: forecastInfo.current.feelslikeF)
        weatherView.updateSunset(sunsetTime: forecastInfo.forecast.forecastday[0].astro.sunset)

    }
    
    func populateHourlyForecastData(forecastInfo: ForecastStruct, index: Int) {
        
        let timeZoneID = forecastInfo.location.tzId
        if let date = convertStringToLocalDate(localTimeString: forecastInfo.location.localtime, timeZoneIdentifier: timeZoneID) {
            var hourIndex: Int = 0
            
            var previousHourlyTimeStruct: HourResult! = nil
            for forecastDay in forecastInfo.forecast.forecastday {
                for hourForecast in forecastDay.hour {
                    if let hourlyTime = convertStringToLocalDate(localTimeString: hourForecast.time, timeZoneIdentifier: timeZoneID) {
                        if hourlyTime > date && hourIndex < 23 {
                            //print(hourIndex)
                            //print()
                            hourlyForecastData[index].append(hourForecast)
                            hourIndex += 1
                        }
                        else if hourIndex < 23 {
                            previousHourlyTimeStruct = hourForecast
                        }
                    }
                }
            }
            
            let nowHourStruct = HourResult(timeEpoch: forecastInfo.location.localtimeEpoch,
                                           time: forecastInfo.location.tzId,
                                           tempC: forecastInfo.current.tempC,
                                           tempF: forecastInfo.current.tempF,
                                           condition: forecastInfo.current.condition,
                                           windMph: forecastInfo.current.windMph,
                                           windKph: forecastInfo.current.windKph,
                                           windDegree: forecastInfo.current.windDegree,
                                           windDir: forecastInfo.current.windDir,
                                           pressureMb: forecastInfo.current.pressureMb,
                                           pressureIn: forecastInfo.current.pressureIn,
                                           precipMm: forecastInfo.current.precipMm,
                                           precipIn: forecastInfo.current.precipIn,
                                           humidity: forecastInfo.current.humidity,
                                           cloud: forecastInfo.current.cloud,
                                           feelslikeC: forecastInfo.current.feelslikeC,
                                           feelslikeF: forecastInfo.current.feelslikeF,
                                           windchillC: previousHourlyTimeStruct.windchillC,
                                           windchillF: previousHourlyTimeStruct.windchillF,
                                           heatindexC: previousHourlyTimeStruct.heatindexC,
                                           heatindexF: previousHourlyTimeStruct.heatindexF,
                                           dewpointC: previousHourlyTimeStruct.dewpointC,
                                           dewpointF: previousHourlyTimeStruct.dewpointF,
                                           willItRain: previousHourlyTimeStruct.willItRain,
                                           willItSnow: previousHourlyTimeStruct.willItSnow,
                                           isDay: forecastInfo.current.isDay,
                                           visKm: previousHourlyTimeStruct.visKm,
                                           visMiles: previousHourlyTimeStruct.visMiles,
                                           chanceOfRain: previousHourlyTimeStruct.chanceOfRain,
                                           chanceOfSnow: previousHourlyTimeStruct.chanceOfSnow,
                                           gustMph: forecastInfo.current.gustMph,
                                           gustKph: forecastInfo.current.gustKph,
                                           uv: forecastInfo.current.uv)
            
            hourlyForecastData[index].insert(nowHourStruct, at: 0)
            
        }
    }
    
    func populateThreeDayForecastData(forecastInfo: ForecastStruct, index: Int) {
        for dayForecast in forecastInfo.forecast.forecastday {
            threeDayForecastData[index].append(dayForecast)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Debug functions
    
    func debugPrintLocationArray() {
        print("THIS IS FOR DEBUG PURPOSES!")
        print(locationsForecastArray)
    }
    
    func debugPrintLocationArrayCount() {
        print("THIS IS FOR DEBUG PURPOSES!")
        print(locationsForecastArray.count)
    }
    
   
    
    
    
}

public let usersInfo = UsersWeatherLocations(locationEnabled: nil)


// MARK: Location Manager
extension UsersWeatherLocations: CLLocationManagerDelegate {
    
    
    
}


// MARK: Date Object Functions
extension UsersWeatherLocations {
    
    func convertStringToLocalDate(localTimeString: String, timeZoneIdentifier: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        // Set the time zone based on the provided time zone identifier
        if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            dateFormatter.timeZone = timeZone
        } else {
            print("Invalid time zone identifier.")
            return nil
        }
        // Parse the local time string into a Date object
        if let date = dateFormatter.date(from: localTimeString) {
            return date
        } else {
            print("Failed to convert the local time string to a Date object.")
            return nil
        }
    }
    
}
