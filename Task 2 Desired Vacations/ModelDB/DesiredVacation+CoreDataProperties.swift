//
//  DesiredVacation+CoreDataProperties.swift
//  Task 2 Desired Vacations
//
//  Created by Nikolay Shiderov on 28.10.21.
//
//

import Foundation
import CoreData


extension DesiredVacation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DesiredVacation> {
        return NSFetchRequest<DesiredVacation>(entityName: "DesiredVacation")
    }

    @NSManaged public var name: String?
    @NSManaged public var hotelName: String?
    @NSManaged public var location: String?
    @NSManaged public var necessaryMoneyAmount: String?
    @NSManaged public var hotelDescription: String?
    @NSManaged public var image: Data?

}

extension DesiredVacation : Identifiable {

}
