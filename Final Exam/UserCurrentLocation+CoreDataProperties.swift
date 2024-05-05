//
//  UserCurrentLocation+CoreDataProperties.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/16/24.
//
//

import Foundation
import CoreData


extension UserCurrentLocation {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCurrentLocation> {
        return NSFetchRequest<UserCurrentLocation>(entityName: "UserCurrentLocation")
    }
    
    @NSManaged public var cityName: String
    
}

extension UserCurrentLocation : Identifiable {
   
    
}
