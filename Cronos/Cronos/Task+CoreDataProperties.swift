//
//  Task+CoreDataProperties.swift
//  Cronos
//
//  Created by Cramer Smith on 6/7/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var attemptDate: NSDate!
    @NSManaged var attemptedToday: NSNumber!
    @NSManaged var completeToday: NSNumber!
    @NSManaged var createdDate: NSDate!
    @NSManaged var elapsedTime: NSNumber!
    @NSManaged var goalTime: NSNumber!
    @NSManaged var isRunning: NSNumber!
    @NSManaged var name: String!
    @NSManaged var startDate: NSDate!
    @NSManaged var onCloud: NSNumber!

}
