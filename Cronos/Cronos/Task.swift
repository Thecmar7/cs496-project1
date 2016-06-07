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
		checkAttemptDate()
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
            return false
        } else {
            updateTask()
            print("Completed: \(self.completedNum), Attempted: \(attemptedNum)")
            return true
        }
	}
    
    func updateTask() {
        completedNum = Double(completedNum) + 1
        save()
        let dict = Dictionary(dictionaryLiteral: ("name", self.name!), ("id", uuid), ("completed", self.completedNum), ("attempted", self.attemptedNum))
        post(dict, url: "http://cronos-1329.appspot.com/cronosServlet?op=update&id=\(uuid)&multiple=false", postCompleted: { (succeeded, msg) in
           if (succeeded) {
               print("Success")
           } else {
               print("Failure")
           }
        })
        print("Completed: \(self.completedNum), Attempted: \(attemptedNum)")
    }
	
	//MARK:Attempted Date Functions
	/*************************************************************************
	*	checkAttemptDate -> (bool, bool)
	*		returns if the task as been attempted and if the app has been
	*		completed
	*************************************************************************/
	func checkAttemptDate() -> (attempted:Double, completed:Double) {
		if (attemptDate == nil || !areDatesSameDay(attemptDate, dateTwo: NSDate())) {
			attemptedNum = Double(attemptedNum) + 1
            attemptDate = NSDate()
		}
		print("Attempted: \(attemptedNum) CompletedToday: \(completedNum)")
		return(Double(attemptedNum), Double(completedNum))
	}
	
	/*************************************************************************
	*	areDatesSameDay -> bool
	*		takes in two dates and returns a if the dates are the same day
	*************************************************************************/
	func areDatesSameDay(dateOne:NSDate,dateTwo:NSDate) -> Bool {
		let calender = NSCalendar.currentCalendar()
		let flags: NSCalendarUnit = [.Day, .Month, .Year]
		let compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
		let compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
		return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
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