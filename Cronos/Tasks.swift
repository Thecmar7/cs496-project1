//
//  Tasks.swift
//  Cronos
//
//  Created by Cramer Smith on 4/22/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class Tasks: NSObject, NSCoding {
	 
	var task: String
	var current: Int
	var estimate: NSTimeInterval
	
	
	// MARK: Types
	
	struct PropertyKey {
		static let estimateKey = "estimate"
		static let currentKey = "current"
		static let taskKey = "task"
	}
	
	// MARK: Archiving Paths
	
	static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("timedtasksdata")
	
	
	// MARK: Initializer
	
	init?(task: String, current: Int, estimate: NSTimeInterval) {
		// Initialize stored properties.
		self.task		= task
		self.current	= current
		self.estimate	= estimate
		
		super.init()
		
		// Initialization should fail if there is no task name or if the estimate or the current is negative .
		if (task.isEmpty || estimate < 0 || current < 0) {
			return nil
		}
	}

	// MARK: NSCoding
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeDouble(estimate, forKey: PropertyKey.estimateKey)
		aCoder.encodeInteger(current, forKey: PropertyKey.currentKey)
		aCoder.encodeObject(task, forKey: PropertyKey.taskKey)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let task = aDecoder.decodeObjectForKey(PropertyKey.taskKey) as! String
		
		// Because photo is an optional property of Meal, use conditional cast.
		let current = aDecoder.decodeIntegerForKey(PropertyKey.currentKey)
		
		let estimate = aDecoder.decodeDoubleForKey(PropertyKey.estimateKey)
		
		// Must call designated initializer.
		self.init(task: task, current: current, estimate: estimate)
	}
	
	
}
