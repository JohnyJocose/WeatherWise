//
//  ForecastStructURLSession.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/8/23.
//

import UIKit


struct ForecastStruct: Codable {
    var location: LocationResult
    let current: CurrentResult
    let forecast: ForecastResult
    
    func printReadableCurrent() {
        print("\nCURRENT FORECAST\nTemperature: \(current.tempF)°\nWeather: \(current.condition.text)\nWind: \(current.windMph) MPH \(current.windDir)\nGust: \(current.gustMph) MPH \(current.windDir)\nPrecipitation: \(current.precipIn) in\nHumidity: \(current.humidity)%\nCloud Cover: \(current.cloud)%\nUV Index: \(current.uv)\n\nLast updated at: \(current.lastUpdated)")
    }
    
    func printReadableLocation() {
        print("\nLOCATION\n\nName: \(location.name)\nRegion: \(location.region)\nCountry: \(location.country)\nLatitude: \(location.lat)\nLongitude: \(location.lon)\n\(location.name)'s Local Time: \(location.localtime)\nTime Zone: \(location.tzId)\n")
    }
    
    func printReadableForecast() {
        for forecastDay in forecast.forecastday {
            print(returnReadableForecastDay(ForecastDay: forecastDay))
        }
    }
    
    func returnReadableForecastDay(ForecastDay: ForecastDayResult) -> String {
        let dateString = "DATE: \(ForecastDay.date)\n"
        let dayString = returnReadableDay(day: ForecastDay.day)
        let astroString = returnReadableAstro(astro: ForecastDay.astro)
        var hoursString = ""
        for hour in ForecastDay.hour {
            hoursString += returnReadableHourForecast(hour: hour)
        }
        
        return dateString + dayString + astroString + hoursString
    }
    
//    let date: String
//    let dateEpoch: Int
//    let day: DayResult
//    let astro: AstroResult
//    let hour: [HourResult]
    
    func returnReadableDay(day: DayResult) -> String {
        return "DAY\nMax Temperature: \(day.maxtempF)\nMin Temperature: \(day.mintempF)\nAverage Temperature: \(day.avgtempF)\nMax Wind: \(day.maxwindMph) MPH\nTotal Precipitation: \(day.totalprecipIn) in\nAverage Humidity: \(day.avghumidity)\nWeather: \(day.condition.text)\nUV Index: \(day.uv)\n\n"
    }
    
    func returnReadableAstro(astro: AstroResult) -> String {
        return "ASTRO\nSunrise: \(astro.sunrise)\nSunset: \(astro.sunset)\nMoonrise: \(astro.moonrise)\nMoonset: \(astro.moonset)\nMoon Phase: \(astro.moonPhase)\nMoon Illumination: \(astro.moonIllumination)\n\n"
    }
    

    func returnReadableHourForecast(hour: HourResult) -> String {
        
        return "HOUR \(hour.time)\nTemperature: \(hour.tempF)°\nWeather: \(hour.condition.text)\nWind: \(hour.windMph) MPH \(hour.windDir)\nGust: \(hour.gustMph) MPH \(hour.windDir)\nPrecipitation: \(hour.precipIn) in\nHumidity: \(hour.humidity)\nCloud Cover: \(hour.cloud)\nFeels Like: \(hour.feelslikeF)°\nWind Chill: \(hour.windchillF)°\nHeat Index: \(hour.heatindexF)°\nDew Point: \(hour.dewpointF)°\nWill it Rain: \(hour.willItRain)\nWill it Snow: \(hour.willItSnow)\nDay or Night?: \(hour.isDay)\nChance of Rain: \(hour.chanceOfRain)%\nChance of Snow: \(hour.chanceOfSnow)%\nUV Index: \(hour.uv)\n\n"
    }
    
    
    
    enum LocationReturnTypes {
        case name
        case region
        case country
        case lat
        case lon
        case localTime
        case timeZone
    }
    
    func returnLocationElementFormat(elementType element: LocationReturnTypes) -> String {
        switch element {
        case .name:
            return String(location.name)
        case .region:
            return String(location.region)
        case .country:
            return String(location.country)
        case .lat:
            return String("\(location.lat)")
        case .lon:
            return String("\(location.lon)")
        case .localTime:
            return String(location.localtime)
        case .timeZone:
            return String(location.tzId)
        }
    }
    
    enum CurrentReturnTypes {
        case temp
        case weatherCondition
        case windMPH
        case gustMPH
        case precipIn
        case humidity
        case cloudCover
        case uv
        case lastUpdated
    }
    
    func returnCurrentElementFormat(elementType element: CurrentReturnTypes) -> String {
        switch element {
        case .temp:
            return String("\(current.tempF)°")
        case .weatherCondition:
            return String(current.condition.text)
        case .windMPH:
            return String("\(current.windMph) MPH \(current.windDir)")
        case .gustMPH:
            return String("\(current.gustMph) MPH")
        case .precipIn:
            return String("\(current.precipIn) in")
        case .humidity:
            return String("\(current.humidity)")
        case .cloudCover:
            return String("\(current.cloud)")
        case .uv:
            return String("\(current.uv)")
        case .lastUpdated:
            return String("\(current.lastUpdated)")
        }
    }
    
}

struct ForecastResult: Codable {
    let forecastday: [ForecastDayResult]
}

struct ForecastDayResult: Codable {
    let date: String
    let dateEpoch: Int
    let day: DayResult
    let astro: AstroResult
    let hour: [HourResult]
}

struct HourResult: Codable {
    let timeEpoch: Int
    let time: String
    let tempC: Decimal
    let tempF: Decimal
    let condition: ConditionResult
    let windMph: Decimal
    let windKph: Decimal
    let windDegree: Int
    let windDir: String
    let pressureMb: Decimal
    let pressureIn: Decimal
    let precipMm: Decimal
    let precipIn: Decimal
    let humidity: Int
    let cloud: Int
    let feelslikeC: Decimal
    let feelslikeF: Decimal
    let windchillC: Decimal
    let windchillF: Decimal
    let heatindexC: Decimal
    let heatindexF: Decimal
    let dewpointC: Decimal
    let dewpointF: Decimal
    let willItRain: Int
    let willItSnow: Int
    let isDay: Int
    let visKm: Decimal
    let visMiles: Decimal
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let gustMph: Decimal
    let gustKph: Decimal
    let uv: Decimal
}

struct AstroResult: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: String
}

struct DayResult: Codable {
    let maxtempC: Decimal
    let maxtempF: Decimal
    let mintempC: Decimal
    let mintempF: Decimal
    let avgtempC: Decimal
    let avgtempF: Decimal
    let maxwindMph: Decimal
    let maxwindKph: Decimal
    let totalprecipMm: Decimal
    let totalprecipIn: Decimal
    let avgvisKm: Decimal
    let avgvisMiles: Decimal
    let avghumidity: Int
    let condition: ConditionResult
    let uv: Decimal
}

struct LocationResult: Codable {
    let lat: Decimal
    let lon: Decimal
    var name: String
    var region: String
    var country: String
    let tzId: String
    let localtimeEpoch: Int
    let localtime: String
}

struct CurrentResult: Codable {
    let lastUpdated: String
    let lastUpdatedEpoch: Int
    let tempC: Decimal
    let tempF: Decimal
    let feelslikeC: Decimal
    let feelslikeF: Decimal
    let condition: ConditionResult
    let windMph: Decimal
    let windKph: Decimal
    let windDegree: Int
    let windDir: String
    let pressureMb: Decimal
    let pressureIn: Decimal
    let precipMm: Decimal
    let precipIn: Decimal
    let humidity: Int
    let cloud: Int
    let isDay: Int
    let uv: Decimal
    let gustMph: Decimal
    let gustKph: Decimal
}

struct ConditionResult: Codable {
    let text: String
    let icon: String
    let code: Int
}


class forecastJson {
    
    static func getForecastDataAsync(lat: Decimal, lon: Decimal) async throws -> ForecastStruct{
        
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=9fe5c95d36584cc9b3600732230610&q=\(lat),\(lon)&days=3&aqi=no&alerts=no"
        guard let url = URL(string: urlString) else {
            throw WeatherAPIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw WeatherAPIError.invalidServerResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ForecastStruct.self, from: data)
            
        } catch {
            print("Error decoding JSON: \(error)")
            throw WeatherAPIError.invalidData
        }
        
    }
}
