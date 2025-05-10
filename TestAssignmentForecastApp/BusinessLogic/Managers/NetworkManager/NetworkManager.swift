//
//  NetworkManager.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import Foundation

protocol NetworkManagerType {
    func isConnected() async throws -> Bool
    func fetchWeather(cityName: String) async throws -> WeatherResponse
    func loadIcon(with code: String) async throws -> Data
}

final class NetworkManager {

    let connectivityService: ConnectivityServiceType
    let weatherService: WeatherServiceType
    let iconService: IconServiceType

    init(
        connectivityService: ConnectivityServiceType,
        weatherService: WeatherServiceType,
        iconService: IconServiceType
    ) {
        self.connectivityService = connectivityService
        self.weatherService = weatherService
        self.iconService = iconService
    }
}

extension NetworkManager: NetworkManagerType {

    func isConnected() async throws -> Bool {
        await connectivityService.checkInternetConnection()
    }

    func fetchWeather(cityName: String) async throws -> WeatherResponse {
        do {
            let forecast = try await weatherService.fetchWeather(cityName: cityName)
            return forecast
        } catch {
            print(error)
            throw error
        }
    }

    func loadIcon(with code: String) async throws -> Data {
        do {
            return try await iconService.fetchIconData(for: code)
        } catch {
            throw error
        }
    }
}
