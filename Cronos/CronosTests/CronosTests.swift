//
//  CronosTests.swift
//  CronosTests
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import XCTest
@testable import Cronos

class CronosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeleteAll() {
        deleteAllTasks()
        assert(tasks.count == 0, "Did not delete all tasks")
    }
    
    func testAddTasks() {
        deleteAllTasks()
        let mintes: Double = 60
        let names = [String](arrayLiteral: "Gardening", "Fishing", "Cleaning")
        let times = [Double](arrayLiteral: 2*mintes, 1*mintes, 3*mintes)
        
        for i in 0..<names.count {
            addTask(names[i], goalTime: times[i])
        }
        loadTasks()
        assert(tasks.count == 3, "Task size not correct")
        print(tasks)
    }
    
    func testNotification() {
        deleteAllTasks()
        addTask("Test", goalTime: 5.0)
        loadTasks()
        let task = tasks[0]
        let time = Double(task.remainingTime) + 1.0
        sleep(UInt32(time))
        assert(task.notification.fireDate?.timeIntervalSinceNow < 0, "Past fire date")
    }
    
    func testChange() {
        deleteAllTasks()
        addTask("New Task", goalTime: 5.0)
        loadTasks()
        let task = tasks[0]
        assert(task.isRunning.boolValue == false)
        task.startTimer()
        print(task.isRunning.boolValue)
        assert(task.isRunning.boolValue == true)
        sleep(6)
        print(task.isRunning.boolValue)
        print(task.goalDate)
        print(NSDate())
        assert(task.isRunning.boolValue == false)
    }
    
}
