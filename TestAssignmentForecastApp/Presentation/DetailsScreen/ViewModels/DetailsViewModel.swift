//
//  DetailsViewModel.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import Foundation

protocol DetailsViewHandler: AnyObject {
    var forecast: Forecast { get }
    var onFetch: (() -> Void)? { get set }
    var onFailure: (() -> Void)? { get set }

    func refresh()
}

final class DetailsViewModel: DetailsViewHandler {

    var forecast: Forecast
    var onFetch: (() -> Void)?
    var onFailure: (() -> Void)?

    private let networkManager: NetworkManagerType
    private let coreDataManager: CoreDataManagerType

    init(
        forecast: Forecast,
        networkManager: NetworkManagerType,
        coreDataManager: CoreDataManagerType
    ) {
        self.forecast = forecast
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }

    func refresh() {
        Task { @MainActor in

            let isConnected = try await networkManager.isConnected()

            if isConnected {
                let updated = try await fetchForecast(city: forecast.city)
                forecast.update(with: updated)
                onFetch?()
            } else {
                onFailure?()
            }


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
