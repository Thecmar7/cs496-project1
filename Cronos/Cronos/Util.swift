//
//  Util.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/23/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK - Constants
var tasks = [NSManagedObject]()

// MARK - Time Functions

// changes the seconds to hour, minute, seconds
func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = (seconds % 3600) % 60
    
    return (hours, minutes, seconds)
}

func formatTime(time: Int) -> String {
    let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(time)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

//MARK - CoreData Functions

func loadTasks() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Task")
    
    do {
        let results = try managedContext.executeFetchRequest(fetchRequest)
        tasks = results as! [NSManagedObject]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
}

func addTask(name: String, estimate: Double) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    
    let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
    
    let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    task.setValue(name, forKey: "name")
    task.setValue(estimate, forKey: "estimateTime")
    
    do {
        try managedContext.save()
        tasks.append(task)
    } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
    }
}