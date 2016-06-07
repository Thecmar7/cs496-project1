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

//MARK: - Delegate Functions

protocol TaskDelegate: class {
    func stopUITimer()
    func goalReached()
}

protocol ModalDissmissDelegate: class {
    func updateVC()
}

protocol StyleDelegate: class {
	func navbarColoring()
}

//MARK: - CoreData Functions

// Load all tasks
func loadTasks() {
    
    let fetchRequest = NSFetchRequest(entityName: "Task")
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "createdDate", ascending: true)]
    
    do {
        let results = try managedContext.executeFetchRequest(fetchRequest)
        tasks = results as! [Task]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
}

// Add a task
func addTask(name: String, goalTime: Double) {
        
    let newTask = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    newTask.setValue(name, forKey: "name")
    newTask.setValue(NSDate(), forKey: "createdDate")
    newTask.setValue(goalTime, forKey: "goalTime")
	
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
    task.stopTimer()
    managedContext.deleteObject(task)
    save()
}

// delete a task at an index
func deleteTask(atIndex index: Int) {
    tasks[index].stopTimer()
    managedContext.deleteObject(tasks[index])
    save()
    loadTasks()
}

func deleteAllTasks() {
    loadTasks()
    while tasks.count > 0 {
        let task = tasks[0]
        if (task.isRunning.boolValue) {
            task.stopTimer()
        }
        deleteTask(atIndex: 0)
    }
}

/**************************************************************************
*		|	|	|--|--|
*		|	|	   |
*		\---\_	|__|__|
**************************************************************************/


/**************************************************************************
*	RGBColor
*		a function to make the changing of color a bit simpler
**************************************************************************/
func RGBColor(r:Double, g:Double, b:Double) -> UIColor {
	return UIColor(red:	  (CGFloat(r) / 255.0),
				   green: (CGFloat(g) / 255.0),
				   blue:  (CGFloat(b) / 255.0),
				   alpha: 1.0)
}

extension UIViewController: StyleDelegate {
	/**************************************************************************
	*	Set up the navbars
	**************************************************************************/
	func navbarColoring() {
		self.navigationController?.navigationBar.barTintColor = RGBColor(100, g: 4, b: 4)
	
		
	}
	
}
