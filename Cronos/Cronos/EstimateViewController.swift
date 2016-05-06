//
//  EstimateViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class EstimateViewController: UIViewController {
	
    var task: Task!
	var UItimer = NSTimer()
	
    @IBOutlet var goalDateDatePicker: UIDatePicker!
	@IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet var goalLabel: UILabel!
    
	//@IBOutlet weak var startAndStop: UIButton!
	@IBOutlet weak var reset: UIButton!
	@IBOutlet var startAndStop: UIButton!
    @IBOutlet var getEstimateButton: UIButton!
	
	// Loading the view first function called
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (task.isRunning) {
            startAndStop.setTitle("Stop", forState: .Normal)
            startUITimer()
        }
        
        // set the delegate to self so the goalReached() alert shows up on this view controller
        task.delegate = self
        
        // hide the date picker and show the label, update labels
        goalDateDatePicker.hidden = true
        goalLabel.text = formatTime(Int(task.estimateTime))
		timeCountLabel.text = formatTime(Int(task.currentTime))
        goalDateDatePicker.countDownDuration = NSTimeInterval(task.estimateTime)
        
        // set title to task name
        self.title = task.name
    }
	
	// Don't touch this... cause reasons
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	//  This is a test function for the selector wheel
    @IBAction func getTimeButtonSelected(sender: UIButton) {
        
        if (sender.titleLabel?.text == "Set Estimate") {
            
            // replace picker with label, change button, update labels
            task.estimateTime = Int(estimateTime.countDownDuration)
            goalLabel.text = formatTime(Int(task.estimateTime))
            goalDateDatePicker.hidden = true
            goalLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
        } else {
            
            // replace label with picker, change button
            goalDateDatePicker.countDownDuration = Double(Int(task.estimateTime))
            goalLabel.hidden = true
            goalDateDatePicker.hidden = false
            getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        }
		
    }
    
    // On finish task stop timer if running
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
	}
	
	// This starts and stops the timer
	@IBAction func startTimer(sender: UIButton) {
		
		if (sender.titleLabel?.text == "Start") {
            
            // hide date picker and show label, update estimate button
            goalDateDatePicker.hidden = true
            goalLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
            
            //start updating the UI as often as the timer updates
            startUITimer()
            
            // starts timer
            task.startTimer()
            
            // change label
			startAndStop.setTitle("Stop", forState: .Normal)
            
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
        UItimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
    }
    
    // Resets tasks currentTime and displays the changes
    func resetTimer() {
        task.stopTimer()
		task.currentTime = 0
		timeCountLabel.text = formatTime(Int(task.currentTime))
        timeCountLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
	}

	// stops the UITimer and the tasks timer which in turn saves the time, also sets the stop button to stop
	func stopTimer() {
        UItimer.invalidate()
		task.stopTimer()
        startAndStop.setTitle("Start", forState: .Normal)
	}
	
    // called whenever the UITimer fires
    func timerSelector() {
        updateUI()
    }
    
    // override goalReached event listener to update UI when user want to keep working
    override func goalReached(sender: Task) {
        print("EstimateVC")
        timeCountLabel.textColor = UIColor.redColor()
        stopTimer()
        let reachedGoalAlertController = UIAlertController(title: "You did it!", message: "You reached your \(sender.name) goal! Do you want to keep going or would you like to stop?", preferredStyle: .Alert)
        let addTimeAction = UIAlertAction(title: "Set new goal and keep going!", style: .Default, handler: {(alert: UIAlertAction!) in
            self.goalDateDatePicker.hidden = false
            self.goalLabel.hidden = true
            self.goalLabel.text = formatTime(Int(sender.estimateTime))
            self.getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        })
        let stopAction = UIAlertAction(title: "Stop working", style: .Destructive, handler: {(alert: UIAlertAction!) in
            //TODO: dismiss estimateVC
            self.goalLabel.text = formatTime(Int(sender.estimateTime))
        })
        reachedGoalAlertController.addAction(addTimeAction)
        reachedGoalAlertController.addAction(stopAction)
        presentViewController(reachedGoalAlertController, animated: true, completion: nil)
    }
    
    // Changes the label of the timer
	func updateUI() {
        timeCountLabel.text = formatTime(Int(task.currentTime))
		timeCountLabel.textColor = UIColor(red: (128 + (128 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, green: (240 - (240 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, blue: (128 - (128 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, alpha: 1.0)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
