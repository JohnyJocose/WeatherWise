//
//  SearchCityURLSession.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/8/23.
//

import UIKit


struct AutoCompleteResult: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Decimal
    let lon: Decimal
}


class searchJson {
    
    static func getSearchDataAsync(area:String) async throws -> [AutoCompleteResult]{
        
        if let encodedArea = area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = "https://api.weatherapi.com/v1/search.json?key=9fe5c95d36584cc9b3600732230610&q=\(encodedArea)"
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
                return try decoder.decode([AutoCompleteResult].self, from: data)
                
            } catch {
                print("Error decoding JSON: \(error)")
                throw WeatherAPIError.invalidData
            }
        } else {
            throw WeatherAPIError.invalidURL
        }
        
    }
}

enum WeatherAPIError: Error {
    case invalidURL
    case invalidServerResponse
    case invalidData
}
