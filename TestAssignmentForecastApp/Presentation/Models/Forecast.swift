//
//  Forecast.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import UIKit

struct Forecast {
    let id: UUID
    var latitude: Double
    var longitude: Double
    var city: String
    var country: String
    var weatherIcon: UIImage?
    var currentTemperature: Int
    var minTemperature: Int
    var maxTemperature: Int
    var humidity: Int
    var windSpeed: Int
}

extension Forecast {

    var currentTemperatureString: String {
        return "\(currentTemperature)°C"
    }

    var minTemperatureString: String {
        return "\(minTemperature)°C"
    }

    var maxTemperatureString: String {
        return "\(maxTemperature)°C"
    }

    var humidityString: String {
        return "\(humidity)%"
    }

    var windSpeedString: String {
        return "\(windSpeed) km/h"
    }
}

extension Forecast {
    init(forecastDTO: WeatherResponse, imageData: Data) {
        self.id = UUID()
        self.latitude = forecastDTO.coord.lat
        self.longitude = forecastDTO.coord.lon
        self.city = forecastDTO.name
        self.country = forecastDTO.sys.country
        self.weatherIcon = UIImage(data: imageData)
        self.currentTemperature = Int(forecastDTO.main.temp)
        self.minTemperature = Int(forecastDTO.main.tempMin)
        self.maxTemperature = Int(forecastDTO.main.tempMax)
        self.humidity = Int(forecastDTO.main.humidity)
        self.windSpeed = Int(forecastDTO.wind.speed)
    }
}

extension Forecast {
    mutating func update(with model: Forecast) {
        self.weatherIcon = model.weatherIcon
        self.currentTemperature = model.currentTemperature
        self.minTemperature = model.minTemperature
        self.maxTemperature = model.maxTemperature
        self.humidity = model.humidity
        self.windSpeed = model.windSpeed
    }
}

extension Forecast: Hashable {}
