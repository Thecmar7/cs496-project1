//
//  Task.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/22/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import Foundation
import CoreData
import UIKit		// For UILocalNotification

class Task: NSManagedObject {
	
	// Insert code here to add functionality to your managed object subclass
	
    var notification: UILocalNotification?
	var delegate: TaskDelegate?
	var goalDate: NSDate?
	
	//MARK: Timer Functions
	/*************************************************************************
	*	startTimer
	*		starts the timer setting and creates a push notification
	*************************************************************************/
	func startTimer() {
		isRunning = true
		startDate = NSDate()
		goalDate = NSDate(timeIntervalSinceNow: Double(self.getRemainingTime()))
		save() // MAYBE?
		
		// set a push notification
        cancelNotification()
		setPushNotificationAlert()
		
		// print values for error checking
//		print("START")
//		print(self)
	}
	
	/*************************************************************************
	*	stopTimer
	*		stops the timer and unsets the push notifications
	*************************************************************************/
	func stopTimer() {
		self.isRunning = false
		self.cancelNotification()
        self.delegate?.stopUITimer()
		
        self.elapsedTime = NSNumber(double: Double(elapsedTime) + Double(abs(startDate.timeIntervalSinceNow)))
		if (Int(elapsedTime) > Int(goalTime)) {
			elapsedTime = goalTime
		}
		save()
		
		//print("STOP")
		//print(self)
	}
	
	/*************************************************************************
	*	resetTimer
	*		stops the timer and makes the time remaining the total time
	*************************************************************************/
	func resetTimer() {
		elapsedTime = 0.0
		startDate = NSDate()
		save()
		
		// cancel local notification
		self.cancelNotification()
		
//		print("RESET")
//		print(self)
	}
	
	
	//MARK: Data Functions
	/*************************************************************************
	 *	getReaminingTime
	 *		gets the remaining time
	 *************************************************************************/
	func getRemainingTime() -> Double {
		return (Double(goalTime!) - Double(elapsedTime!)) + (startDate?.timeIntervalSinceNow)!
	}
	
	/*************************************************************************
	 *	setGoalTime
	 *		sets a new goal time and updates relative values
	 *************************************************************************/
	func setNewGoalTime(newTime: Double) {
		self.goalTime = newTime
		self.goalDate = NSDate(timeIntervalSinceNow: Double(self.getRemainingTime()))
		self.cancelNotification()
        
        if (self.isRunning.boolValue) {
            self.setPushNotificationAlert()
        }
		
		save()
		
//		print(self)
	}
	
	/*************************************************************************
	 *	getViewTime
	 *		gets the time that the view should display
	 *************************************************************************/
	func getViewTime() -> Double {
		if (self.isRunning.boolValue) {
			return abs(self.startDate.timeIntervalSinceNow) + Double(self.elapsedTime)
		} else {
			return Double(self.elapsedTime)
		}
	}
	
	/*************************************************************************
	 *	checkIfIsRunning
	 *		check if the timer should or still is running
	 *************************************************************************/
	func checkIfIsRunning() -> Bool {
		if (self.isRunning.boolValue && getRemainingTime() > Double(self.goalTime)) {
			self.isRunning = false
		}
		return self.isRunning.boolValue
	}
	
	/*************************************************************************
	*	checkIfGoalReached
	*       sends true if now is past goal date
	*************************************************************************/
	func checkIfGoalReached() -> Bool {
        if (goalDate?.timeIntervalSinceNow < 0) {
            return true
        } else {
            return false
        }
	}
	
	//MARK: Notification Functions
	
	/*************************************************************************
	 *	setPushNotificationAlert
	 *		creates a push notification to be called when timer finishes
	 *************************************************************************/
	func setPushNotificationAlert() {
        self.notification = UILocalNotification()
		self.notification!.alertBody = "You reached your \(self.name) goal!"
		self.notification!.alertAction = "Yay!"						        
		self.notification!.fireDate = self.goalDate							
		self.notification!.soundName = UILocalNotificationDefaultSoundName	
		self.notification!.userInfo = ["title": self.name!]
		
		UIApplication.sharedApplication().scheduleLocalNotification(self.notification!)
	}
	
	/*************************************************************************
	*	cancelNotification
	*		cancels the notification for this task
	*************************************************************************/
	func cancelNotification() {
        if (self.notification != nil) {
            UIApplication.sharedApplication().cancelLocalNotification(self.notification!)
        }
	}
	
	
}