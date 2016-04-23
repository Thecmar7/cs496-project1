//
//  CronosTests.swift
//  CronosTests
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import XCTest
@testable import Cronos
import CoreData

class CronosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddTasks() {
        var tasks = [NSManagedObject]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
        
        let taskNames = ["Design", "Coding", "Homework"]
        let estimates = [Double](arrayLiteral: (3*3600), (5*3600), (7*3600))
        
        for i in 0..<taskNames.count {
            let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            let newTaskName = taskNames[i]
            let newTaskEstimate = estimates[i]
            task.setValue(newTaskName, forKey: "name")
            task.setValue(newTaskEstimate, forKey: "estimateTime")
            
            do {
                try managedContext.save()
                
                tasks.append(task)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        assert(tasks.count == 3)
        
    }
    
}
