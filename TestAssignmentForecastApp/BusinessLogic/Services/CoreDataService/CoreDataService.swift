//
//  CoreDataService.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import CoreData
import UIKit

protocol CoreDataServiceType {
    func createOrUpdate(_ model: WeatherResponse, imageData: Data, context: NSManagedObjectContext)
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func fetch<T: NSManagedObject>(
        _ managedObject: T.Type,
        completion: (Result<[T], Error>) -> Void
    )
}

final class CoreDataService {

    private let persistentContainer: NSPersistentContainer

    private lazy var readContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    private lazy var writeContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()

    init() {
        ValueTransformer.setValueTransformer(
            UIImageTransformer(),
            forName: NSValueTransformerName("UIImageTransformer")
        )
        
        persistentContainer = NSPersistentContainer(
            name: "TestAssignmentForecastApp"
        )
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }

    }
}

extension CoreDataService: CoreDataServiceType {
    func createOrUpdate(_ model: WeatherResponse, imageData: Data, context: NSManagedObjectContext) {
        if let existingForecast = fetchForecast(by: model.name, context: context) {
            existingForecast.latitude = model.coord.lat
            existingForecast.longitude = model.coord.lon
            existingForecast.city = model.name
            existingForecast.country = model.sys.country
            existingForecast.currentTemperature = Int16(model.main.temp.rounded())
            existingForecast.weatherIcon = UIImage(data: imageData)
            existingForecast.minTemperature = Int16(model.main.tempMin.rounded())
            existingForecast.maxTemperature = Int16(model.main.tempMax.rounded())
            existingForecast.humidity = Int16(model.main.humidity)
            existingForecast.windSpeed = Int16(model.wind.speed.rounded())
        } else {
            let forecastEntity = ForecastEntity(context: context)
            forecastEntity.longitude = model.coord.lon
            forecastEntity.city = model.name
            forecastEntity.country = model.sys.country
            forecastEntity.currentTemperature = Int16(model.main.temp.rounded())
            forecastEntity.weatherIcon = UIImage(data: imageData)
            forecastEntity.minTemperature = Int16(model.main.tempMin.rounded())
            forecastEntity.maxTemperature = Int16(model.main.tempMax.rounded())
            forecastEntity.humidity = Int16(model.main.humidity)
            forecastEntity.windSpeed = Int16(model.wind.speed.rounded())
            forecastEntity.longitude = model.coord.lon
            forecastEntity.city = model.name
        }
    }

    private func fetchForecast(by name: String, context: NSManagedObjectContext) -> ForecastEntity? {
        do {
            return try context.fetch(ForecastEntity.fetchRequest() as NSFetchRequest<ForecastEntity>)
                .first { $0.city == name }
        } catch {
            print(error)
            return nil
        }
    }

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
        context.perform {
            block(context)

            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetch<T>(
        _ managedObject: T.Type,
        completion: (Result<[T], Error>) -> Void
    ) where T : NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(
            entityName: String(describing: T.self)
        )

        do {
            let dbObject = try readContext.fetch(fetchRequest)
            completion(.success(dbObject))
        } catch {
            completion(.failure(error))
        }
    }
}
