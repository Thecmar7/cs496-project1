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

// MARK: - Constants
var tasks = [Task]()
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let managedContext = appDelegate.managedObjectContext
let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)

// MARK: - Time Functions

// Define TaskDelegate, this declares an event listener
protocol TaskDelegate: class {
    func goalReached(sender: Task)
}

// Make all UIViewControllers conform to TaskDelegate meaning they all have a goalReached() that executes as follows
extension UIViewController: TaskDelegate {
    
    // when sender's goal is reached alert the user
    func goalReached(sender: Task) {
        sender.stopTimer()
        let reachedGoalAlertController = UIAlertController(title: "You did it!", message: "You reached your \(sender.name) goal! Do you want to keep going or would you like to stop?", preferredStyle: .Alert)
        let addTimeAction = UIAlertAction(title: "Set new goal and keep going!", style: .Default, handler: nil)
        let stopAction = UIAlertAction(title: "Stop working", style: .Destructive, handler: nil)
        reachedGoalAlertController.addAction(addTimeAction)
        reachedGoalAlertController.addAction(stopAction)
        presentViewController(reachedGoalAlertController, animated: true, completion: nil)
    }
}

// changes the seconds to hour, minute, seconds
func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = (seconds % 3600) % 60
    
    return (hours, minutes, seconds)
}

// formats an integer (number of seconds) into a timestamp string
func formatTime(time: Int) -> String {
    let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(time)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

//MARK: - CoreData Functions

// Load all tasks
func loadTasks() {
    
    let fetchRequest = NSFetchRequest(entityName: "Task")
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
    
    do {
        let results = try managedContext.executeFetchRequest(fetchRequest)
        tasks = results as! [Task]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
}

// Add a task
func addTask(name: String, estimate: Int) {
        
    let newTask = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    newTask.setValue(name, forKey: "name")
    newTask.setValue(estimate, forKey: "estimateTime")
    
    save()
    loadTasks()
}

func updateTask(task: NSManagedObject, value: AnyObject, key: String) {
    task.setValue(value, forKey: key)
    save()
}

func save() {
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not delete \(error), \(error.userInfo)")
    }
}

func deleteTask(task: Task) {
    managedContext.deleteObject(task)
    save()
}

// delete a task at an index
func deleteTask(atIndex: Int) {
    managedContext.deleteObject(tasks[atIndex])
    save()
    loadTasks()
}

func deleteAllTasks() {
    loadTasks()
    while tasks.count > 0 {
        deleteTask(0)
    }
}