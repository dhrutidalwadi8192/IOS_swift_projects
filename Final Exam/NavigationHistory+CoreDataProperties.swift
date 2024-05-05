//
//  NavigationHistory+CoreDataProperties.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/14/24.
//
//

import Foundation
import CoreData


extension NavigationHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NavigationHistory> {
        return NSFetchRequest<NavigationHistory>(entityName: "NavigationHistory")
    }

    @NSManaged public var city: String?
    @NSManaged public var from: String?
    @NSManaged public var historyId: UUID?
    @NSManaged public var humidity: String?
    @NSManaged public var interactionType: String?
    @NSManaged public var newsAuthor: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var source: String?
    @NSManaged public var temperature: String?
    @NSManaged public var to: String?
    @NSManaged public var totalDistance: String?
    @NSManaged public var travelMode: String?
    @NSManaged public var weatherDate: String?
    @NSManaged public var windSpeed: String?
    @NSManaged public var weatherTime: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var newsSource: String?

}

extension NavigationHistory : Identifiable {

}
