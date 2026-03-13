//
//  WeatherView.swift
//  TripMate
//
//  Created by iMac on 13/03/26.
//

import SwiftUI
import Combine

struct WeatherView: View {
    
    let cityName: String
    @StateObject private var weatherService = WeatherService()
    
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    if weatherService.isLoading {
                        ProgressView()
                            .tint(Color.AccentColor)
                            .padding(.top, 50)
                        
                    } else if !weatherService.errorMessage.isEmpty {
                        errorView
                        
                    } else if let weather = weatherService.currentWeather {
                        currentWeatherCard(weather)
                        
                        // Alert banner
                        if let alert = weatherService.weatherAlert(
                            weather.weather.first?.main ?? "",
                            temp: weather.main.temp
                        ) {
                            alertBanner(alert)
                        }
                        
                        // Forecast
                        if !weatherService.forecast.isEmpty {
                            forecastSection
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Weather")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            weatherService.fetchWeather(for: cityName)
            weatherService.fetchForecast(for: cityName)
        }
    }
    
    // MARK: - Current Weather Card
    private func currentWeatherCard(_ weather: WeatherResponse) -> some View {
        VStack(spacing: 16) {
            
            // City name
            Text(weather.name.uppercased())
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.6))
                .kerning(3)
            
            // Emoji + Temp
            VStack(spacing: 8) {
                Text(weatherService.weatherEmoji(weather.weather.first?.main ?? ""))
                    .font(.system(size: 80))
                
                Text("\(Int(weather.main.temp))°C")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(Color.AccentColor)
                
                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(Color.AccentColor.opacity(0.6))
            }
            
            Divider()
                .background(Color.AccentColor.opacity(0.2))
            
            // Stats row
            HStack(spacing: 0) {
                weatherStat(icon: "thermometer", label: "Feels Like", value: "\(Int(weather.main.feelsLike))°C")
                Divider().frame(height: 40)
                weatherStat(icon: "humidity", label: "Humidity", value: "\(weather.main.humidity)%")
                Divider().frame(height: 40)
                weatherStat(icon: "wind", label: "Wind", value: "\(Int(weather.wind.speed)) m/s")
            }
            
            // Min/Max
            HStack {
                Label("\(Int(weather.main.tempMin))°C", systemImage: "arrow.down")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.blue.opacity(0.7))
                Spacer()
                Label("\(Int(weather.main.tempMax))°C", systemImage: "arrow.up")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding(20)
        .background(Color.BackgroundColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.AccentColor.opacity(0.08), radius: 10, y: 4)
    }
    
    // MARK: - Weather Stat
    private func weatherStat(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.AccentColor.opacity(0.6))
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
            Text(label)
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Alert Banner
    private func alertBanner(_ message: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(message)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundColor(Color.AccentColor)
            Spacer()
        }
        .padding(14)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Forecast Section
    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5-DAY FORECAST")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.6))
                .kerning(2)
            
            VStack(spacing: 8) {
                ForEach(weatherService.forecast) { item in
                    forecastRow(item)
                }
            }
        }
        .padding(20)
        .background(Color.BackgroundColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.AccentColor.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Forecast Row
    private func forecastRow(_ item: ForecastItem) -> some View {
        HStack {
            // Day
            Text(dayFromDate(item.dtTxt))
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .frame(width: 80, alignment: .leading)
            
            // Emoji
            Text(weatherService.weatherEmoji(item.weather.first?.main ?? ""))
                .font(.system(size: 20))
            
            Spacer()
            
            // Temp
            Text("\(Int(item.main.tempMax))° / \(Int(item.main.tempMin))°")
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.7))
        }
        .padding(.vertical, 6)
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 12) {
            Image(systemName: "cloud.bolt")
                .font(.system(size: 44))
                .foregroundColor(Color.AccentColor.opacity(0.4))
            Text(weatherService.errorMessage)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.6))
            Button {
                weatherService.fetchWeather(for: cityName)
                weatherService.fetchForecast(for: cityName)
            } label: {
                Text("RETRY")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.AccentColor.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding(.top, 50)
    }
    
    // MARK: - Helper
    private func dayFromDate(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateStr) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE, MMM d"
            return dayFormatter.string(from: date)
        }
        return dateStr
    }
}

#Preview {
    NavigationStack {
        WeatherView(cityName: "Surat")
    }
}
