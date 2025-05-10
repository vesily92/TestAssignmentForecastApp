//
//  ForecastService.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import Foundation

protocol WeatherServiceType {
    func fetchWeather(
        cityName: String
    ) async throws -> WeatherResponse
}

final class WeatherService: WeatherServiceType {

    func fetchWeather(
        cityName: String
    ) async throws -> WeatherResponse {
        guard let url = OpenWeatherEndpoint.currentWeather(city: cityName).url else {
            throw NetworkError.invalidURLError()
        }

        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse,
              http.url == url,
              (200..<300).contains(http.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NetworkError.badResponseError(statusCode: statusCode)
        }

        let decoder = JSONDecoder()

        do {
            let decoded = try decoder.decode(WeatherResponse.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailureError(error)
        }
    }
}
