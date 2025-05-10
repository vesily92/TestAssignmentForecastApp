//
//  WeatherResponse.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Weather: Codable {
    let icon: String
}

struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp, tempMin = "temp_min", tempMax = "temp_max"
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
}

struct Sys: Codable {
    let country: String
}
