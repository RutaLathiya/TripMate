//
//  WeatherService.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import Foundation
import CoreLocation
import Combine

// MARK: - Weather Models
struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main: MainWeather
    let wind: Wind
    let name: String
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Double
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable, Identifiable {
    var id: String { dtTxt }
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - Weather Service
class WeatherService: ObservableObject {
    
    private let apiKey = "8f9a2f5c7bfede607e14cb2ba4928084"  // 👈 paste your key here
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    @Published var currentWeather: WeatherResponse? = nil
    @Published var forecast: [ForecastItem] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // Fetch current weather by city name
    func fetchWeather(for city: String) {
        isLoading = true
        errorMessage = ""
        
        let urlString = "\(baseURL)/weather?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)&appid=\(apiKey)&units=metric"
        
        //print("🌤️ Fetching: \(urlString)")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    if let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                        self.currentWeather = decoded
                    } else {
                        self.errorMessage = "City not found"
                    }
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Failed to fetch"
                }
            }
        }.resume()
    }
    
    // Fetch 5-day forecast by city name
    func fetchForecast(for city: String) {
        let urlString = "\(baseURL)/forecast?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data,
                   let decoded = try? JSONDecoder().decode(ForecastResponse.self, from: data) {
                    // get one forecast per day (every 24h)
                    self.forecast = decoded.list.enumerated()
                        .filter { $0.offset % 8 == 0 }
                        .map { $0.element }
                }
            }
        }.resume()
    }
    
    // Weather emoji from condition
    func weatherEmoji(_ condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "☀️"
        case "clouds": return "☁️"
        case "rain": return "🌧️"
        case "drizzle": return "🌦️"
        case "thunderstorm": return "⛈️"
        case "snow": return "❄️"
        case "mist", "fog", "haze": return "🌫️"
        default: return "🌤️"
        }
    }
    
    // Weather alert message
    func weatherAlert(_ condition: String, temp: Double) -> String? {
        if temp > 40 { return "🔥 Extreme heat warning" }
        if temp < 0 { return "🥶 Freezing conditions ahead" }
        if condition.lowercased() == "thunderstorm" { return "⛈️ Thunderstorm alert" }
        if condition.lowercased() == "snow" { return "❄️ Snowfall expected" }
        return nil
    }
}
