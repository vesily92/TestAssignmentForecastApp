//
//  ForecastEntity.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//
//

import CoreData
import UIKit

@objc(ForecastEntity)
public class ForecastEntity: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var city: String
    @NSManaged public var country: String
    @NSManaged public var weatherIcon: UIImage?
    @NSManaged public var currentTemperature: Int16
    @NSManaged public var maxTemperature: Int16
    @NSManaged public var minTemperature: Int16
    @NSManaged public var humidity: Int16
    @NSManaged public var windSpeed: Int16
}
