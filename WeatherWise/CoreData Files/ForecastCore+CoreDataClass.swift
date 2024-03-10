//
//  ForecastCore+CoreDataClass.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 3/9/24.
//
//

import Foundation
import CoreData

@objc(ForecastCore)
public class ForecastCore: NSManagedObject {
    func createForecastStruct(coreInfo: ForecastCore) -> ForecastStruct{
        
        let currentVariable = coreCurrentToCurrentResult(coreCurrent: coreInfo.current!)
        let forecastVariable = coreForecastToForecastResult(coreForecast: coreInfo.forecast!)
        let locationVariable = coreLocationToLocationResult(coreLocation: coreInfo.location!)
        
        let forecast = ForecastStruct(location: locationVariable, current: currentVariable, forecast: forecastVariable)
        return forecast
    }
    
    
    func coreLocationToLocationResult(coreLocation: Location) -> LocationResult {
        
        return LocationResult(lat: coreLocation.lat! as Decimal,
                              lon: coreLocation.lon! as Decimal,
                              name: coreLocation.name!,
                              region: coreLocation.region!,
                              country: coreLocation.country!,
                              tzId: coreLocation.tzId!,
                              localtimeEpoch: Int(coreLocation.localtimeEpoch),
                              localtime: coreLocation.localtime!)
    }
    
    
    
    
    
    func coreForecastToForecastResult(coreForecast: Forecast) -> ForecastResult {
        
        var coreForecastDayArray: [ForecastDay] = []
        for day in coreForecast.forecastDay! {
            coreForecastDayArray.append(day as! ForecastDay)
        }
        let forecastDayVariable = coreForecastDayToForecastDayResult(coreForecastDay: coreForecastDayArray)
                    
        return ForecastResult(forecastday: forecastDayVariable)
        
        
        
        
    }
    
    func coreForecastDayToForecastDayResult(coreForecastDay: [ForecastDay]) -> [ForecastDayResult] {
        
        var returnForecastDayArray: [ForecastDayResult] = []
        
        
        
        for forecastDay in coreForecastDay {
            let dateVariable = forecastDay.date!
            let dateEpochVariable = Int(forecastDay.dateEpoch)
            let dayVariable = coreDayToDayResult(coreDay: forecastDay.day!)
            let astroVariable = coreAstroToAstroResult(coreAstro: forecastDay.astro!)
            
            var coreHourArray: [Hour] = []
            for hour in forecastDay.hour! {
                coreHourArray.append(hour as! Hour)
            }
            let hourVariable = coreHourToHourResult(coreHour: coreHourArray)
                        
            returnForecastDayArray.append(ForecastDayResult(date: dateVariable,
                                                            dateEpoch: dateEpochVariable,
                                                            day: dayVariable,
                                                            astro: astroVariable,
                                                            hour: hourVariable))
            
        }
        
        return returnForecastDayArray
        
        
    }
    
    func coreDayToDayResult(coreDay: Day) -> DayResult {
        let conditionVariable = coreConditionToConditionResult(coreCondition: coreDay.condition!)
        
        return DayResult(maxtempC: coreDay.maxtempC! as Decimal,
                         maxtempF: coreDay.maxtempF! as Decimal,
                         mintempC: coreDay.mintempC! as Decimal,
                         mintempF: coreDay.mintempF! as Decimal,
                         avgtempC: coreDay.avgtempC! as Decimal,
                         avgtempF: coreDay.avgtempF! as Decimal,
                         maxwindMph: coreDay.maxwindMph! as Decimal,
                         maxwindKph: coreDay.maxwindKph! as Decimal,
                         totalprecipMm: coreDay.totalprecipMm! as Decimal,
                         totalprecipIn: coreDay.totalprecipIn! as Decimal,
                         avgvisKm: coreDay.avgvisKm! as Decimal,
                         avgvisMiles: coreDay.avgvisMiles! as Decimal,
                         avghumidity: Int(coreDay.avghumidity),
                         condition: conditionVariable,
                         uv: coreDay.uv! as Decimal)
    }
    
    func coreAstroToAstroResult(coreAstro: Astro) -> AstroResult {
        return AstroResult(sunrise: coreAstro.sunrise!,
                           sunset: coreAstro.sunset!,
                           moonrise: coreAstro.moonrise!,
                           moonset: coreAstro.moonset!,
                           moonPhase: coreAstro.moonPhase!,
                           moonIllumination: coreAstro.moonIllumination! as Decimal)
        
    }
    
    func coreHourToHourResult(coreHour: [Hour]) -> [HourResult] {
        
        var returnHourArray: [HourResult] = []
        for hour in coreHour {
            let conditionVariable = coreConditionToConditionResult(coreCondition: hour.condition!)
            returnHourArray.append(HourResult(timeEpoch: Int(hour.timeEpoch),
                                              time: hour.time!,
                                              tempC: hour.tempC! as Decimal,
                                              tempF: hour.tempF! as Decimal,
                                              condition: conditionVariable,
                                              windMph: hour.windMph! as Decimal,
                                              windKph: hour.windKph! as Decimal,
                                              windDegree: Int(hour.windDegree),
                                              windDir: hour.windDir!,
                                              pressureMb: hour.pressureMb! as Decimal,
                                              pressureIn: hour.pressureIn! as Decimal,
                                              precipMm: hour.precipMm! as Decimal,
                                              precipIn: hour.precipIn! as Decimal,
                                              humidity: Int(hour.humidity),
                                              cloud: Int(hour.cloud),
                                              feelslikeC: hour.feelslikeC! as Decimal,
                                              feelslikeF: hour.feelslikeF! as Decimal,
                                              windchillC: hour.windchillC! as Decimal,
                                              windchillF: hour.windchillF! as Decimal,
                                              heatindexC: hour.heatindexC! as Decimal,
                                              heatindexF: hour.heatindexF! as Decimal,
                                              dewpointC: hour.dewpointC! as Decimal,
                                              dewpointF: hour.dewpointF! as Decimal,
                                              willItRain: Int(hour.willItRain),
                                              willItSnow: Int(hour.willItSnow),
                                              isDay: Int(hour.isDay),
                                              visKm: hour.visKm! as Decimal,
                                              visMiles: hour.visMiles! as Decimal,
                                              chanceOfRain: Int(hour.chanceOfRain),
                                              chanceOfSnow: Int(hour.chanceOfSnow),
                                              gustMph: hour.gustMph! as Decimal,
                                              gustKph: hour.gustKph! as Decimal,
                                              uv: hour.uv! as Decimal))
        }
        
        return returnHourArray
        
    }
    
    
    
    func coreCurrentToCurrentResult(coreCurrent: Current) -> CurrentResult {
        
        let conditionVariable = coreConditionToConditionResult(coreCondition: coreCurrent.condition!)
        
        return CurrentResult(lastUpdated: coreCurrent.lastUpdated!,
                             lastUpdatedEpoch: Int(coreCurrent.lastUpdatedEpoch),
                             tempC: coreCurrent.tempC! as Decimal,
                             tempF: coreCurrent.tempF! as Decimal,
                             feelslikeC: coreCurrent.feelslikeC! as Decimal,
                             feelslikeF: coreCurrent.feelslikeF! as Decimal,
                             condition: conditionVariable,
                             windMph: coreCurrent.windMph! as Decimal,
                             windKph: coreCurrent.windKph! as Decimal,
                             windDegree: Int(coreCurrent.windDegree),
                             windDir: coreCurrent.windDir!,
                             pressureMb: coreCurrent.pressureMb! as Decimal,
                             pressureIn: coreCurrent.precipIn! as Decimal,
                             precipMm: coreCurrent.precipMm! as Decimal,
                             precipIn: coreCurrent.precipIn! as Decimal,
                             humidity: Int(coreCurrent.humidity),
                             cloud: Int(coreCurrent.cloud),
                             isDay: Int(coreCurrent.isDay),
                             uv: coreCurrent.uv! as Decimal,
                             gustMph: coreCurrent.gustMph! as Decimal,
                             gustKph: coreCurrent.gustKph! as Decimal)
    }
    
    func coreConditionToConditionResult(coreCondition: Condition) -> ConditionResult {
        
        return ConditionResult(text: coreCondition.text!,
                               icon: coreCondition.icon!,
                               code: Int(coreCondition.code)
        )
        
    }
}
