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
    
    var delegate: MainVC!
    
    var locationDelegate: LocationVC!
    
    
    // We're using a timer to update the weather views every 15 min.
    var timer: Timer!
    

    var locationsForecastArray: [ForecastStruct] = []
    var forecastWeatherPages: [WeatherView] = [WeatherView()]
    
    var hourlyForecastData: [[HourResult]] = []
    var threeDayForecastData: [[ForecastDayResult]] = []
    
    
    
    
    
    
    var locationEnabled: Bool?
    
    var skipToLocation: Bool?
    
    
    
    override init() {
        super.init()
        configureLocationManager()
        startUpdateTimer()
        
        
    }
    
    func startUpdateTimer() {
        
        // update the weather in 15 min increments
        timer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true, block: { [self] timer in
            
            Task {
                if delegate != nil || locationDelegate != nil{
                    
                    if let delegate {
                        await delegate.startLoading()
                        await delegate.disableEverything()
                    }

                    hourlyForecastData.removeAll()
                    threeDayForecastData.removeAll()
                    
                    for i in 0..<locationsForecastArray.count {
                        if locationEnabled == true && i == 0 {
                            updateWeatherInfo(forecast: locationsForecastArray[i], index: i, usersLocation: true)
                        }
                        else {
                            updateWeatherInfo(forecast: locationsForecastArray[i], index: i)
                        }
                    }
                    
                    if delegate != nil || locationDelegate != nil{
                        
                        hourlyForecastData.removeAll()
                        threeDayForecastData.removeAll()
                        
                        for i in 0..<locationsForecastArray.count {
                            if locationEnabled == true && i == 0 {
                                updateWeatherInfo(forecast: locationsForecastArray[i], index: i, usersLocation: true)
                            }
                            else {
                                updateWeatherInfo(forecast: locationsForecastArray[i], index: i)
                            }
                        }
                        
                        if locationDelegate != nil {
                            await locationDelegate.mainDelegate.updateScrollView()
                            await locationDelegate.mainDelegate.stopLoading()
                            await locationDelegate.mainDelegate.enableEverything()
                            
                        }
                        else {
                            await delegate.updateScrollView()
                            await delegate.stopLoading()
                            await delegate.enableEverything()
                            
                        }
                    }
                }
            }
            
            
        })
    }
    
    func updateWeatherInfo(forecast: ForecastStruct, index: Int, usersLocation: Bool = false) {
        
        
        Task {
            var result = try await forecastJson.getForecastDataAsync(lat: forecast.location.lat, lon: forecast.location.lon)
            
            // When searching locations by latitude and longitude, sometimes the API returns the city as a whole instead of the specific area we need.
            // I will adjust the struct to ensure the correct location is saved in Core Data.
            
            if !usersLocation {
                result.location.name = forecast.location.name
                result.location.region = forecast.location.region
                result.location.country = forecast.location.country
            }
            
            locationsForecastArray[index] = result
        }
        
    }
    
    func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.delegate = self
        requestPermissionToAccessLocation()
    }
    
    func requestPermissionToAccessLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            commenceLocationDenied()
            locationEnabled = false
        case .authorizedAlways:
            skipToLocation = false
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            skipToLocation = false
            locationManager.startUpdatingLocation()
        @unknown default:
            commenceLocationDenied()
            locationEnabled = false
        }
    }
    
    func commenceLocationEnabled() {
        if locationEnabled == nil || locationEnabled == false {
            
        }
    }
    
    
    func commenceLocationDenied() {
        
        if locationEnabled == true {
            locationsForecastArray.remove(at: 0)
            forecastWeatherPages.remove(at: 0)
        }
        locationEnabled = false
        if !isUsersLocationsEmpty() {
            if let delegate {
                delegate.updateScrollView()
                
                delegate.changeNumberOfPagesInPageControl(arrayCount: locationsForecastArray.count, currentPage: 0)
                delegate.changeScrollViewBasedOnArray(index: delegate.oldPageTracker)
                
                delegate.changeFirstPageIndicatorImage(LocationOn: false)
                
                
                
                
            }
        }
        
        if isUsersLocationsEmpty() {
            if forecastWeatherPages.isEmpty {
                forecastWeatherPages.append(WeatherView())
            }
            if let delegate {
                delegate.updateScrollView()
                delegate.changeNumberOfPagesInPageControl(arrayCount: forecastWeatherPages.count, currentPage: 0)
                delegate.changeFirstPageIndicatorImage(LocationOn: false)
            }
            
            skipToLocation = true
        }
        
        if let locationDelegate {
            locationDelegate.locationTable.reloadData()
            if returnUsersLocationsCount() == 0 {
                locationDelegate.changeTableEditing(status: false)
            }
        }
        
        
    }
    


    
    
    
    
    
    func addWeatherPage() {
        forecastWeatherPages.append(WeatherView())
        if let delegate {
            delegate.updateScrollView()
        }
    }
    
    
    
    
    
    
    func addLocation(location: ForecastStruct) {
        locationsForecastArray.append(location)
        skipToLocation = false
        
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
    
    
    func returnLocationNameForLocationVC(at index: Int) -> String {
        if index == 0 && locationEnabled == true {
            return "My Location - \(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
        }
        return "\(locationsForecastArray[index].location.name), \(locationsForecastArray[index].location.region)"
    }
    
    
    
    // MARK: CoreData/API Functions
    func updateAllWeatherViews() {
        
        hourlyForecastData.removeAll()
        threeDayForecastData.removeAll()
        
        for i in 0..<usersInfo.returnUsersLocationsCount(){
            
            
            hourlyForecastData.append([])
            threeDayForecastData.append([])
            
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
        
        weatherView.updateTimeZone(timeZoneID: forecastInfo.location.tzId)
        
        if locationEnabled == true && index == 0 {
            weatherView.updateStackLabels(location: "My Location - \(forecastInfo.location.name), \(forecastInfo.location.region)", temperature: tempString, weather: forecastInfo.current.condition.text, highLow: highLowString)
        }
        else {
            weatherView.updateStackLabels(location: "\(forecastInfo.location.name), \(forecastInfo.location.region)", temperature: tempString, weather: forecastInfo.current.condition.text, highLow: highLowString)
        }
        
        
        
        weatherView.updateHourData(hourForecast: hourlyForecastData[index])
        weatherView.updateThreeDayHourData(threeDayForecast: threeDayForecastData[index])
        weatherView.updateHumidty(humidity: forecastInfo.current.humidity)
        weatherView.updateFeelsLike(feelsLike: forecastInfo.current.feelslikeF)
        weatherView.updateMoonPhase(moonPhase: forecastInfo.forecast.forecastday[0].astro.moonPhase)
        weatherView.updateSunset(sunsetTime: forecastInfo.forecast.forecastday[0].astro.sunset)

    }
    
    // This function adds all the hourly forecast data and at the very end we add the now to it
    func populateHourlyForecastData(forecastInfo: ForecastStruct, index: Int) {
        
        
        let timeZoneID = forecastInfo.location.tzId
        if let date = convertStringToLocalDate(localTimeString: forecastInfo.location.localtime, timeZoneIdentifier: timeZoneID) {
            var hourIndex: Int = 0
            
            var previousHourlyTimeStruct: HourResult! = nil
            for forecastDay in forecastInfo.forecast.forecastday {
                for hourForecast in forecastDay.hour {
                    if let hourlyTime = convertStringToLocalDate(localTimeString: hourForecast.time, timeZoneIdentifier: timeZoneID) {
                        if hourlyTime > date && hourIndex < 23 {
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
                                           time: forecastInfo.location.localtime,
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

public let usersInfo = UsersWeatherLocations()


// MARK: Location Manager
extension UsersWeatherLocations: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .authorizedAlways:
            skipToLocation = false
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            skipToLocation = false
            manager.startUpdatingLocation()
        default:
            print("Location Denied")
            commenceLocationDenied()
            locationEnabled = false
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            manager.stopUpdatingLocation()
            createUsersLocationStruct(lat: Decimal(location.coordinate.latitude), lon: Decimal(location.coordinate.longitude))
        }
    }
    
    func createUsersLocationStruct(lat: Decimal, lon: Decimal) {
        Task {
            let result = try await forecastJson.getForecastDataAsync(lat: lat, lon: lon)
            //print(result.printReadableForecast())
            
            if locationEnabled == nil || locationEnabled == false {
                
                if locationEnabled == false {
                    await forecastWeatherPages.insert(WeatherView(), at: 0)
                    if !isUsersLocationsEmpty(){
                        if let delegate {
                            await delegate.updateScrollView()
                            
                            await delegate.changeNumberOfPagesInPageControl(arrayCount: forecastWeatherPages.count, currentPage: 0)
                            await delegate.changeScrollViewBasedOnArray(index: delegate.oldPageTracker)
                            await delegate.changeFirstPageIndicatorImage(LocationOn: true)
                        }
                    }
                }
                locationsForecastArray.insert(result, at: 0)
                if locationEnabled == nil {
                    await delegate.updateScrollView()
                }
                locationEnabled = true
                
                
                
                if let locationDelegate {
                    await locationDelegate.locationTable.reloadData()
                    if returnUsersLocationsCount() == 1 {
                        await locationDelegate.changeTableEditing(status: false)
                    }
                    if let mainDelegate = await locationDelegate.mainDelegate {
                        if forecastWeatherPages.count != locationsForecastArray.count {
                            usersInfo.forecastWeatherPages.removeLast()
                        }
                        await mainDelegate.updateScrollView()
                    }
                }
                
            }
            else {
                locationsForecastArray.remove(at: 0)
                locationsForecastArray.insert(result, at: 0)
                
                if let locationDelegate {
                    await locationDelegate.locationTable.reloadData()
                    
                }
                // update the current string of the location list in location vc
            }
            
            
            
            DispatchQueue.main.async {
                
                self.updateAllWeatherViews()
            }
            
        }
    }
    
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
