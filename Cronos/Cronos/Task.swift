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
	
	var notification = UILocalNotification()
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
		setPushNotificationAlert()
		
		// print values for error checking
		print("START")
		print(self)
	}
	
	/*************************************************************************
	*	stopTimer
	*		stops the timer and unsets the push notifications
	*************************************************************************/
	func stopTimer() {
		self.isRunning = false
		self.cancelNotification()
		self.delegate?.stopUITimer()
        print("Elapsed Time before change: \(elapsedTime)")
		self.elapsedTime = NSNumber(double: Double(elapsedTime) + Double(abs(startDate.timeIntervalSinceNow)))
		save()
		
		print("STOP")
		print(self)
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
		
		print("RESET")
		print(self)
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
		self.setPushNotificationAlert()
		
		save()
		
		print(self)
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
	*	setPushNotificationAlert
	*		creates a push notification to be called at the final day
	*************************************************************************/
	func checkIfGoalReached() -> Bool {
		return (goalDate?.timeIntervalSinceNow < 0)
	}
	
	//MARK: Notification Functions
	
	/*************************************************************************
	 *	setPushNotificationAlert
	 *		creates a push notification to be called at the final day
	 *************************************************************************/
	func setPushNotificationAlert() {
		notification.alertBody = "You reached your \(self.name) goal!"	// text that will be displayed in the notification
		notification.alertAction = "Yay!"								// text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = self.goalDate							// todo item due date (when notification will be fired)
		notification.soundName = UILocalNotificationDefaultSoundName	// play default sound
		notification.userInfo = ["title": self.name!]					// assign a unique identifier to the notification so that we can retrieve it later
		
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