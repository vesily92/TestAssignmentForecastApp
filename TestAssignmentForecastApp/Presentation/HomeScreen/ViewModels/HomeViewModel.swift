//
//  HomeViewModel.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import Foundation

protocol HomeViewHandler: AnyObject {
    var forecasts: [Forecast] { get }
    var onFetch: (() -> Void)? { get set }
    var onFailure: (() -> Void)? { get set }
    
    func render()
    func refresh()
}

class HomeViewModel: HomeViewHandler {

    private let networkManager: NetworkManagerType
    private let coreDataManager: CoreDataManagerType

    var onFetch: (() -> Void)?
    var onFailure: (() -> Void)?

    private(set) var forecasts: [Forecast] = []
    private var isConnectedToNetwork: Bool = false


    private let cities: [String] = [
        "Tel Aviv",
        "Saint Petersburg",
        "Munich",
        "Barcelona",
        "Vancouver",
        "Hong Kong"
    ]

    init(
        networkManager: NetworkManagerType,
        coreDataManager: CoreDataManagerType
    ) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager

        checkNetworkConnection()

    }

    func checkNetworkConnection() {
        Task { isConnectedToNetwork = try await networkManager.isConnected() }
    }

    func render() {
        coreDataManager.fetch { result in
            switch result {
            case .success(let forecasts):
                if isConnectedToNetwork {
                    Task { @MainActor in
                        await update(forecasts)
                        onFetch?()
                    }
                } else {
                    self.forecasts = forecasts
                    onFailure?()
                }

            case .failure(let error):
                print(error)
                break
            }
        }
    }

    func refresh() {
        Task { @MainActor in

            let isConnected = try await networkManager.isConnected()

            if isConnected {
                for var forecast in forecasts {
                    let updated = try await fetchForecast(city: forecast.city)
                    forecast.update(with: updated)
                }
                
                onFetch?()
            } else {
                onFailure?()
            }
        }
    }

    private func update(_ forecasts: [Forecast]) async {
        do {
            if forecasts.isEmpty {
                for city in cities {
                    let new = try await fetchForecast(city: city)
                    self.forecasts.append(new)
                }
            } else {
                for forecast in forecasts {
                    let updated = try await fetchForecast(city: forecast.city)
                    self.forecasts.append(updated)
                }
            }
        } catch {
            print(error)
        }
    }

    private func fetchForecast(city: String) async throws -> Forecast {
        do {
            let forecastDTO = try await networkManager.fetchWeather(cityName: city)
            let imageData = try await networkManager.loadIcon(
                with: forecastDTO.weather.first?.icon ?? ""
            )
            coreDataManager.createOrUpdate(with: forecastDTO, imageData: imageData)
            return Forecast(forecastDTO: forecastDTO, imageData: imageData)
        } catch {
            print(error)
            throw error
        }
    }
}
