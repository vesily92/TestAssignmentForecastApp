//
//  OpenWeatherEndpoint.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 10.05.2025.
//

import Foundation

enum OpenWeatherEndpoint {
    case currentWeather(city: String, units: String = "metric")
    case icon(code: String, size: Int = 2)

    var url: URL? {
        switch self {
        case .currentWeather(let city, let units):
            var comps = URLComponents()
            comps.scheme = OpenWeatherEndpoint.scheme
            comps.host = OpenWeatherEndpoint.weatherHost
            comps.path = OpenWeatherEndpoint.weatherPath
            comps.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: OpenWeatherEndpoint.apiKey),
                URLQueryItem(name: "units", value: units)
            ]
            return comps.url

        case .icon(let code, let size):
            var comps = URLComponents()
            comps.scheme = OpenWeatherEndpoint.scheme
            comps.host = OpenWeatherEndpoint.iconHost
            comps.path = "\(OpenWeatherEndpoint.iconPathPrefix)/\(code)@\(size)x.png"
            return comps.url
        }
    }


    private static let scheme = "https"
    private static let weatherHost = "api.openweathermap.org"
    private static let weatherPath = "/data/2.5/weather"
    private static let iconHost = "openweathermap.org"
    private static let iconPathPrefix = "/img/wn"

    private static let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"
}
