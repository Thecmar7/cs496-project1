//
//  Task+CoreDataProperties.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 5/6/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var createdDate: NSDate!
    @NSManaged var elapsedTime: NSNumber!
    @NSManaged var goalDate: NSDate!
    @NSManaged var isRunning: NSNumber!
    @NSManaged var name: String!
    @NSManaged var remainingTime: NSNumber!
    @NSManaged var startDate: NSDate!
    @NSManaged var goalTime: NSNumber!

}
