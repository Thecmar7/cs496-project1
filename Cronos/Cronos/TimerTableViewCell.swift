//
//  TimerTableViewCell.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell, TaskDelegate {
    
    @IBOutlet var taskName: UILabel!
    @IBOutlet var timeActual: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var task: Task!
    var UItimer = NSTimer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	/***************************************************************************
	*	startTimer
	*		This starts and stops the timer
	**************************************************************************/
    @IBAction func startButton(sender: UIButton) {
        
        if (Double(task.elapsedTime) >= Double(task.goalTime)) {
            let newGoalTimeAlert = UIAlertController(title: "Oops!", message: "You've already reached your goal! To start this task, please select a higher goal", preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil);
            newGoalTimeAlert.addAction(okayAction)
            super.window?.rootViewController?.presentViewController(newGoalTimeAlert, animated: true, completion: nil)
            return
        }
        
		if (startButton.titleLabel!.text! == "Start") {
			//start updating the UI as often as the timer updates
			startUITimer()
			task.startTimer()
			
			timeActual.textColor = UIColor.blackColor()
			
			// change label
			startButton.setTitle("Stop", forState: .Normal)
			startButton.setTitleColor(RGBColor(200.0, g: 0.0, b: 0.0), forState: .Normal)
		} else {
			// stops timer
			stopUITimer()
			timeActual.textColor = UIColor.grayColor()
		}
    }
    
	/***************************************************************************
	*	startUITimer
	*		update the UI every time the task updates
	**************************************************************************/
	func startUITimer() {
		UItimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
		                                                 target: self,
		                                                 selector: #selector(updateUI),
		                                                 userInfo: nil,
		                                                 repeats: true)
		NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
	}
	
	/**************************************************************************
	*	updateUI
	*		Changes the label of the timer
	**************************************************************************/
	func updateUI() {
		timeActual.text = formatTime(Int(task.getViewTime()))
		//timeActual.textColor = RGBColor(0.0, g: 0.0, b: 0.0)
	}
    
	/***************************************************************************
	*	stopUITimer
	*		update the UI every time the task updates
	**************************************************************************/
	func stopUITimer() {
		UItimer.invalidate()
		if (task.checkIfIsRunning()) {
			task.stopTimer()
		}
		startButton.setTitle("Start", forState: .Normal)
		startButton.setTitleColor(RGBColor(0.0, g: 200.0, b: 0.0), forState: .Normal)
	}
	
	/***************************************************************************
	*	goalReached
	*		Sets elapsed time label to the goal time
	*		Delegate calls this
	**************************************************************************/
    func goalReached() {
        timeActual.text = formatTime(Int(task.goalTime))
    }
}
