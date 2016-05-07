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
    
    //MARK: Timer Functions
	
	/*************************************************************************
	 *	startTimer
	 *		starts the timer setting and creates a push notification
	 *************************************************************************/
    func startTimer() {
        
        isRunning = true
        goalDate = NSDate(timeIntervalSinceNow: Double(remainingTime))
        print("Goal Date: \(goalDate)")
        startDate = NSDate()
        print("Start Date: \(startDate)")
        print("isRunning: \(isRunning.boolValue)")
        save()
            
        // set a push notification
        setPushNotificationAlert()
    }
	
	/*************************************************************************
	 *	stopTimer
	 *		stops the timer and unsets the push notifications
	 *************************************************************************/
    func stopTimer() {
        isRunning = false
        remainingTime = abs(goalDate.timeIntervalSinceNow)
        print("remainingTime: \(remainingTime)")
        elapsedTime = NSNumber(double: abs(Double(elapsedTime)) + abs(Double(startDate.timeIntervalSinceNow)))
        print("elapsedTime: \(elapsedTime)")
        print("isRunning: \(isRunning.boolValue)")
        save()
    }
	
	/*************************************************************************
	 *	resetTimer
	 *		stops the timer and makes the time remaining the total time
	 *************************************************************************/
	func resetTimer() {
		isRunning = false
		remainingTime = Double(remainingTime) + Double(elapsedTime)
		elapsedTime = 0.0
        save()
		
		// cancel local notification
		self.cancelNotification()
	}
	
    
    //MARK: Data Functions
    
    /*************************************************************************
     *	setGoalTime
     *		sets a new goal time and updates relative values
     *************************************************************************/
    func setNewGoalTime(newTime: Double) {
        self.goalTime = newTime
        
        if (self.isRunning.boolValue) {
            self.cancelNotification()
        }
        
        self.goalDate = NSDate(timeIntervalSinceNow: newTime)
        self.setPushNotificationAlert()
        
        save()
        
        print("New Goal Date: \(goalDate)")
    }
    
    
    //MARK: Notification Functions
	
	/*************************************************************************
	 *	setPushNotificationAlert
	 *		creates a push notification to be called at the final day
	 *************************************************************************/
	func setPushNotificationAlert() {
		notification.alertBody = "You reached your \(self.name) goal!" // text that will be displayed in the notification
		notification.alertAction = "View task" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = self.goalDate // todo item due date (when notification will be fired)
		notification.soundName = UILocalNotificationDefaultSoundName // play default sound
		notification.userInfo = ["title": self.name!] // assign a unique identifier to the notification so that we can retrieve it later
		
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
