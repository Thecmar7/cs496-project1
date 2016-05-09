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
        // style the buttons
		// reset button
		resetButton.layer.cornerRadius = resetButton.frame.size.height / 4
		resetButton.layer.borderWidth = 2
		resetButton.layer.borderColor = self.view.tintColor.CGColor
		resetButton.backgroundColor = self.view.tintColor
		
		// start and stop button
		startAndStopButton.layer.cornerRadius = startAndStopButton.frame.size.height / 4
		startAndStopButton.layer.borderWidth = 2
		if (task.isRunning.boolValue) {
			startAndStopButton.layer.borderColor = UIColor.redColor().CGColor
			startAndStopButton.backgroundColor = UIColor.redColor()
		} else {
			startAndStopButton.layer.borderColor = UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0).CGColor
			startAndStopButton.backgroundColor = UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0)
		}
		
		super.viewDidLoad()
    }
	
	/***************************************************************************
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
            //startAndStopButton.setTitleColor(UIColor.redColor(), forState: .Normal)
			startAndStopButton.backgroundColor = UIColor.redColor()
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
		elapsedTimeLabel.textColor = UIColor(red: (0 + (256 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0,
											 green: (240 - (240 / ((CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime)))/2) / 255.0,
											 blue: (128 - (128 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0, alpha: 1.0)
		
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (task.isRunning.boolValue) {
			UItimer.invalidate()
		}
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
			
            // change label
			startAndStopButton.setTitle("Stop", forState: .Normal)
            //startAndStopButton.setTitleColor(UIColor.redColor(), forState: .Normal)
			startAndStopButton.backgroundColor = UIColor.redColor()
			startAndStopButton.layer.borderColor = UIColor.redColor().CGColor
			
            // starts timer
            task.startTimer()
            
            
            
        // if label is stop, stop the timer
		} else if (sender.titleLabel?.text == "Stop") {
			// stops timer
			stopTimer()
            task.stopTimer()
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
    
    func goalReached() {
        elapsedTimeLabel.text = formatTime(Int(task.goalTime))
    }
	
	/***************************************************************************
	 *	resetTimer
	 *		Resets tasks currentTime and displays the changes
	 **************************************************************************/
    func resetTimer() {
        if (task.isRunning.boolValue) {
            stopUITimer()
        }
        task.resetTimer()
        UIcounter = 0
		elapsedTimeLabel.text = formatTime(Int(task.elapsedTime))
        elapsedTimeLabel.textColor = UIColor(red: 0/255.0,
                                             green: 0/255.0,
                                             blue: 0/255.0,
                                             alpha: 1.0)
		startAndStopButton.layer.borderColor = UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0).CGColor
	}
	/***************************************************************************
	 *	stopTimer
	 *		stops the UITimer and the tasks timer which in turn saves the time,
	 *		also sets the stop button to stop
	 **************************************************************************/
	func stopTimer() {
        UItimer.invalidate()
        startAndStopButton.setTitle("Start", forState: .Normal)
        //startAndStopButton.setTitleColor(self.view.tintColor, forState: .Normal)
		
		startAndStopButton.layer.borderColor = UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0).CGColor
		startAndStopButton.backgroundColor = UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0)
	}
	
	/**************************************************************************
	 *	updateUI
	 *		Changes the label of the timer
	 **************************************************************************/
	func updateUI() {
        UIcounter! += 1
        elapsedTimeLabel.text = formatTime(UIcounter)
		elapsedTimeLabel.textColor=UIColor(red: (0 + (256 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0,
		                                   green: (240 - (240 / ((CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime)))/2) / 255.0,
		                                   blue: (128 - (128 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0,
		                                   alpha: 1.0)
		
	}

}
