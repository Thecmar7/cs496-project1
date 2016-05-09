//
//  GoalDetailViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController, TaskDelegate {
	// The task
    var task: Task!
	
	// the timer to update the UI
	var UItimer = NSTimer()
    var UIcounter: Int!
	
	/***** MARK: UIInteractables **********************************************/
	@IBOutlet var resetButton: UIButton!
	@IBOutlet var startAndStopButton: UIButton!
    @IBOutlet var getGoalButton: UIButton!
	@IBOutlet var goalDateDatePicker: UIDatePicker!
	
	/***** MARK: UILabels *****************************************************/
	@IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
	
	
	
	/**************************************************************************
	 *	viewDidLoad
	 *		initial set up of the view
	 **************************************************************************/
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	/**************************************************************************
	*	viewWillAppear
	*		initial set up of the view
	**************************************************************************/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIcounter = Int(task.elapsedTime)
		task.delegate = self
        
        // Do any additional setup after loading the view.
        if (task.isRunning.boolValue) {
            startAndStopButton.setTitle("Stop", forState: .Normal)
            startAndStopButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            startUITimer()
        }
        
        // hide the date picker and show the label, update labels
        goalDateDatePicker.hidden = true
        goalLabel.text = formatTime(Int(task.goalTime))
        elapsedTimeLabel.text = formatTime(UIcounter)
        
        goalDateDatePicker.countDownDuration = NSTimeInterval(task.elapsedTime)
        
        // set title to task name
        self.title = task.name
        
        // set appropriate color for elapsed time
        let total = Double(task.remainingTime)
        elapsedTimeLabel.textColor = UIColor(red: (128 + (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0,
                                             green: (240 - (240 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0,
                                             blue: (128 - (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0,
                                             alpha: 1.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (task.isRunning.boolValue) { UItimer.invalidate() }
    }
	
	/***************************************************************************
	 *	didReceiveMemoryWarning
	 *		Don't touch this cause reasons
	 **************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	/***************************************************************************
	 *	getTimeButtonSelected
	 *		This is a test function for the selector wheel
	 **************************************************************************/
    @IBAction func editGoalAction(sender: UIButton) {
        if (sender.titleLabel?.text == "Set Goal") {
            // replace picker with label, change button, update labels
            task.setNewGoalTime(goalDateDatePicker.countDownDuration)
            goalLabel.text = formatTime(Int(task.goalTime))
            goalDateDatePicker.hidden = true
            goalLabel.hidden = false
            getGoalButton.setTitle("Edit Goal", forState: .Normal)
        } else {
            // replace label with picker, change button
            goalDateDatePicker.countDownDuration = Double(task.goalTime)
            goalLabel.hidden = true
            goalDateDatePicker.hidden = false
            getGoalButton.setTitle("Set Goal", forState: .Normal)
        }
		
    }
	
	/***************************************************************************
	 *	finishTaskAction
	 *		On finish task stop timer if running
	 **************************************************************************/
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
	}
	
	/***************************************************************************
	 *	startTimer
	 *		This starts and stops the timer
	 **************************************************************************/
	@IBAction func startTimer(sender: UIButton) {
		if (sender.titleLabel?.text == "Start") {
            // hide date picker and show label, update estimate button
            goalDateDatePicker.hidden = true
            goalLabel.hidden = false
            getGoalButton.setTitle("Edit Goal", forState: .Normal)
            
            //start updating the UI as often as the timer updates
            startUITimer()
            
            // starts timer
            task.startTimer()
            
            // change label
			startAndStopButton.setTitle("Stop", forState: .Normal)
            startAndStopButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            
        // if label is stop, stop the timer
		} else if (sender.titleLabel?.text == "Stop") {
			// stops timer
			stopTimer()

		}
	}
	
	/***************************************************************************
	*	resetTimerAction
	*		This sets the timer back to 
	**************************************************************************/
	@IBAction func resetTimerAction(sender: UIButton) {
		resetTimer()
    }

    // MARK: Functions

	/***************************************************************************
	 *	startUITimer
	 *		update the UI every time the task updates
	 **************************************************************************/
    func startUITimer() {
        UItimer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                         target: self,
                                                         selector: #selector(updateUI),
                                                         userInfo: nil,
                                                         repeats: true)
        NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
    }
    
    func stopUITimer() {
        stopTimer()
        if (task.isRunning.boolValue) {
            stopTimer()
            task.stopTimer()
        }
    }
	
	/***************************************************************************
	 *	resetTimer
	 *		Resets tasks currentTime and displays the changes
	 **************************************************************************/
    func resetTimer() {
        if (task.isRunning.boolValue) {
            stopTimer()
        }
        task.resetTimer()
        UIcounter = 0
		elapsedTimeLabel.text = formatTime(Int(task.elapsedTime))
        elapsedTimeLabel.textColor = UIColor(red: 0/255.0,
                                             green: 0/255.0,
                                             blue: 0/255.0,
                                             alpha: 1.0)
	}
	/***************************************************************************
	 *	stopTimer
	 *		stops the UITimer and the tasks timer which in turn saves the time,
	 *		also sets the stop button to stop
	 **************************************************************************/
	func stopTimer() {
        UItimer.invalidate()
        startAndStopButton.setTitle("Start", forState: .Normal)
        startAndStopButton.setTitleColor(self.view.tintColor, forState: .Normal)
	}
	
	/**************************************************************************
	 *	updateUI
	 *		Changes the label of the timer
	 **************************************************************************/
	func updateUI() {
        UIcounter! += 1
        elapsedTimeLabel.text = formatTime(UIcounter)
		let total = Double(task.remainingTime) + Double(UIcounter)
		elapsedTimeLabel.textColor = UIColor(red: (128 + (128 / (CGFloat(total))) * CGFloat(Int(task.elapsedTime))) / 255.0,
		                                     green: (240 - (240 / (CGFloat(total))) * CGFloat(Int(task.elapsedTime))) / 255.0,
		                                     blue: (128 - (128 / (CGFloat(total))) * CGFloat(Int(task.elapsedTime))) / 255.0,
		                                     alpha: 1.0)
	}

}
