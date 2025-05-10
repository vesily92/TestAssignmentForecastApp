//
//  CoreDataManager.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import Foundation

protocol CoreDataManagerType {
    func createOrUpdate(with model: WeatherResponse, imageData: Data)
    func fetch(completion: (Result<[Forecast], Error>) -> Void)
}

final class CoreDataManager {

    let coreDataService: CoreDataServiceType

    init(coreDataService: CoreDataServiceType) {
        self.coreDataService = coreDataService
    }
}

extension CoreDataManager: CoreDataManagerType {
    func createOrUpdate(with model: WeatherResponse, imageData: Data) {
        coreDataService.performSave { [weak self] context in
            self?.coreDataService.createOrUpdate(model, imageData: imageData, context: context)
        }
    }

    func fetch(completion: (Result<[Forecast], Error>) -> Void) {
        coreDataService.fetch(ForecastEntity.self) { result in
            switch result {
            case .success(let entities):
                var models: [Forecast] = []

                entities.forEach { forecast in
                    let model = Forecast(
                        id: UUID(),
                        latitude: forecast.latitude,
                        longitude: forecast.longitude,
                        city: forecast.city,
                        country: forecast.country,
                        weatherIcon: forecast.weatherIcon,
                        currentTemperature: Int(forecast.currentTemperature),
                        minTemperature: Int(forecast.minTemperature),
                        maxTemperature: Int(forecast.maxTemperature),
                        humidity: Int(forecast.humidity),
                        windSpeed: Int(forecast.windSpeed)
                    )
                    models.append(model)
                }
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
