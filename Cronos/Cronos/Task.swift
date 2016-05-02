//
//  Task.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/22/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import Foundation
import CoreData


class Task: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var timer = NSTimer()
    var counter = 0
    var isRunning = false
    
    func startTimer() {
        counter = Int(currentTime)
        isRunning = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.incrementCounter), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
        updateTask(self, value: counter, key: "currentTime")
    }
    
    func incrementCounter() {
        counter += 1
        currentTime = NSNumber(double: Double(counter))
    }

}
