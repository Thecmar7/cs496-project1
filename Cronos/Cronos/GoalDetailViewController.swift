//
//  GoalDetailViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {
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
	
	
	
	/***** MARK: viewDidLoad **************************************************
	 *	initial set up of the view
	 **************************************************************************/
	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIcounter = Int(task.elapsedTime)
        
        // Do any additional setup after loading the view.
        if (task.isRunning.boolValue) {
            startAndStopButton.setTitle("Stop", forState: .Normal)
            startAndStopButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            startUITimer()
        }
        
        // hide the date picker and show the label, update labels
        goalDateDatePicker.hidden = true
        goalLabel.text = formatTime(Int(task.remainingTime))
        elapsedTimeLabel.text = formatTime(UIcounter)
        
        goalDateDatePicker.countDownDuration = NSTimeInterval(task.elapsedTime)
        
        // set title to task name
        self.title = task.name
    }
	
	/***** MARK: didReceiveMemoryWarning **************************************
	*	Don't touch this cause reasons
	***************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	/***** MARK: getTimeButtonSelected ****************************************
	*	This is a test function for the selector wheel
	***************************************************************************/
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
            goalDateDatePicker.countDownDuration = Double(task.remainingTime) + Double(task.elapsedTime)
            goalLabel.hidden = true
            goalDateDatePicker.hidden = false
            getGoalButton.setTitle("Set Goal", forState: .Normal)
        }
		
    }
	
	/***** MARK: finishTaskAction *********************************************
	 *	On finish task stop timer if running
	 **************************************************************************/
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
	}
	
	/***** MARK: startTimer **************************************************
	 *	This starts and stops the timer
	 *************************************************************************/
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
	
    // reset timer when reset button pressed
	@IBAction func resetTimerAction(sender: UIButton) {
		resetTimer()
    }

    // MARK: Functions
    
    // update the UI every time the task updates
    func startUITimer() {
        UItimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
    }
    
    // Resets tasks currentTime and displays the changes
    func resetTimer() {
        task.resetTimer()
		elapsedTimeLabel.text = formatTime(Int(task.elapsedTime))
        elapsedTimeLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
	}

	// stops the UITimer and the tasks timer which in turn saves the time, also sets the stop button to stop
	func stopTimer() {
        UItimer.invalidate()
		task.stopTimer()
        startAndStopButton.setTitle("Start", forState: .Normal)
        startAndStopButton.setTitleColor(self.view.tintColor, forState: .Normal)
	}
    
    // Changes the label of the timer
	func updateUI() {
        UIcounter! += 1
        elapsedTimeLabel.text = formatTime(UIcounter)
		let total = UIcounter
		elapsedTimeLabel.textColor = UIColor(red: (128 + (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, green: (240 - (240 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, blue: (128 - (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, alpha: 1.0)
	}

}
