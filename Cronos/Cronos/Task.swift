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
    
    var delegate: TaskDelegate?
    var notification = UILocalNotification()
    
    
    func startTimer() {
        
        isRunning = true
        goalDate = NSDate(timeIntervalSinceNow: Double(remainingTime))
        startDate = NSDate()
            
        // set a push notification
        setPushNotificationAlert()
    }
    
    func stopTimer() {
        isRunning = false
        remainingTime = goalDate.timeIntervalSinceNow
        elapsedTime = NSNumber(double: Double(elapsedTime) + Double(startDate.timeIntervalSinceNow))
        
        // cancel local notification
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
	
	
	// Will push notification
	func setPushNotificationAlert() {
		notification.alertBody = "You reached your \(name) goal!" // text that will be displayed in the notification
		notification.alertAction = "View task" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
		notification.fireDate = goalDate // todo item due date (when notification will be fired)
		notification.soundName = UILocalNotificationDefaultSoundName // play default sound
		notification.userInfo = ["title": self.name!] // assign a unique identifier to the notification so that we can retrieve it later
		
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}

}
