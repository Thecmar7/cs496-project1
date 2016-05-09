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
    
    var notification = UILocalNotification()
    var delegate: TaskDelegate?
    
    var timer = NSTimer()
    var counter = 0
    
    //MARK: Timer Functions
	
	/*************************************************************************
	 *	startTimer
	 *		starts the timer setting and creates a push notification
	 *************************************************************************/
    func startTimer() {
		
        self.cancelNotification()
        isRunning = true
        startDate = NSDate()
        remainingTime = Double(goalTime) - Double(elapsedTime)
		goalDate = NSDate(timeIntervalSinceNow: Double(remainingTime))
        counter = Int(elapsedTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(incrementCounter), userInfo: nil, repeats: true)
        save()
            
        // set a push notification
        setPushNotificationAlert()
        
        // print values
		print("START")
        print(self)
    }
	
	/*************************************************************************
	 *	stopTimer
	 *		stops the timer and unsets the push notifications
	 *************************************************************************/
    func stopTimer() {
        
        isRunning = false
        self.cancelNotification()
        self.timer.invalidate()
        var currentTimeLeft = goalDate.timeIntervalSinceNow
		print(currentTimeLeft)
        if (currentTimeLeft > 0) {
            currentTimeLeft = abs(goalDate.timeIntervalSinceNow)
        } else {
            currentTimeLeft = 0.0
        }
        remainingTime = currentTimeLeft
        delegate?.stopUITimer()
//        elapsedTime = NSNumber(double: abs(Double(elapsedTime)) + abs(Double(startDate.timeIntervalSinceNow)))
        save()
		
		print("STOP")
        print(self)
    }
	
	/*************************************************************************
	 *	resetTimer
	 *		stops the timer and makes the time remaining the total time
	 *************************************************************************/
	func resetTimer() {
        self.timer.invalidate()
		remainingTime = goalTime
		elapsedTime = 0.0
        counter = 0;
        save()
		
		// cancel local notification
		self.cancelNotification()
		
		print("RESET")
        print(self)
	}
    
    func incrementCounter() {
        counter += 1
        remainingTime = Int(remainingTime) - 1
        elapsedTime = counter
    }
	
    
    //MARK: Data Functions
    
    /*************************************************************************
     *	setGoalTime
     *		sets a new goal time and updates relative values
     *************************************************************************/
    func setNewGoalTime(newTime: Double) {
        self.remainingTime = Double(goalTime) - Double(elapsedTime)
        self.goalTime = newTime
        
        if (self.isRunning.boolValue) {
            self.cancelNotification()
            self.goalDate = NSDate(timeIntervalSinceNow: newTime)
            self.setPushNotificationAlert()
        }
        
        save()
        
        print(self)
    }
    
    
    //MARK: Notification Functions
	
	/*************************************************************************
	 *	setPushNotificationAlert
	 *		creates a push notification to be called at the final day
	 *************************************************************************/
	func setPushNotificationAlert() {
		notification.alertBody = "You reached your \(self.name) goal!"	// text that will be displayed in the notification
		notification.alertAction = "View task"				// text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = self.goalDate				// todo item due date (when notification will be fired)
		notification.soundName = UILocalNotificationDefaultSoundName	// play default sound
		notification.userInfo = ["title": self.name!]		// assign a unique identifier to the notification so that we can retrieve it later
		
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
    
    /*************************************************************************
     *	cancelNotification
     *		cancels the notification for this task
     *************************************************************************/
    func cancelNotification() {
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }

}
