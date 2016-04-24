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
        
        let taskNames = ["Design", "Coding", "Homework"]
        let estimates = [Int](arrayLiteral: (3*3600), (5*3600), (7*3600))
        
        deleteAllTasks()
        
        for i in 0..<taskNames.count {
            addTask(taskNames[i], estimate: estimates[i])
        }
        
        assert(tasks.count == 3, "Failed add count")
        for i in 0..<taskNames.count {
            assert(tasks[i].valueForKey("name") as? String == taskNames[i], "Failed name assertion")
        }
        
    }
    
    func testModifyTask() {
        loadTasks()
        if (tasks.count == 0) {
            addTask("Running", estimate: Int(0.5*3600))
        }
        let task = tasks[0]
        let oldName = task.valueForKey("name") as? String
        let newName = "Gardening"
        assert(oldName != newName, "Already Gardening")
        updateTask(task, value: newName, key: "name")
        loadTasks()
        let updatedTask = tasks[0]
        let updatedName = updatedTask.valueForKey("name") as? String
        
        assert(updatedName == newName, "Name not updated")
        
    }
    
}
