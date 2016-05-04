//
//  Task.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/22/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Task: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var timer = NSTimer()
    var counter = 0
    var isRunning = false
    var delegate: TaskDelegate?
	
	// The great Date refactor...
	var startDate = NSDate()
	var estimateEndDate = NSDate()
	var timeLeft = NSTimeInterval()
    
    
    func startTimer() {
		counter = Int(currentTime)
        isRunning = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.incrementCounter), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)

		// the great Date refactor....
		startDate = NSDate(timeIntervalSinceNow: 0.0)
		estimateEndDate = NSDate(timeIntervalSinceNow: NSTimeInterval(self.estimateTime))
		print("startDate:\(startDate) estimateEndDate: \(estimateEndDate) ")
		setPushNotificationAlert()
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
        updateTask(self, value: counter, key: "currentTime")
    }
    
    func incrementCounter() {
        counter += 1
        currentTime = NSNumber(double: Double(counter))
        
        // This is the call to the event listener
        if (Double(currentTime) >= Double(estimateTime)) {
			delegate?.goalReached(self)
		}
    }
	
	/*************The great date refactor*****************/
	
	// Will push notification
	func setPushNotificationAlert() {
		let notification = UILocalNotification()
		notification.alertBody = "poop" // text that will be displayed in the notification
		notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = estimateEndDate // todo item due date (when notification will be fired)
		notification.soundName = UILocalNotificationDefaultSoundName // play default sound
		notification.userInfo = ["title": self.name] // assign a unique identifier to the notification so that we can retrieve it later
		
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

}
