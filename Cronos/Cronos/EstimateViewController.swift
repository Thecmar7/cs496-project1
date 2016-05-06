//
//  EstimateViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class EstimateViewController: UIViewController {
	// The task
    var task: Task!
	
	// the timer to update the UI
	var UItimer = NSTimer()
	
	/***** MARK: UIInteractables **********************************************/
	@IBOutlet weak var reset: UIButton!
	@IBOutlet var startAndStop: UIButton!
    @IBOutlet var getEstimateButton: UIButton!
	@IBOutlet var goalDateDatePicker: UIDatePicker!
	
	/***** MARK: UILabels *****************************************************/
	@IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet var goalLabel: UILabel!
	
	
	
	/***** MARK: viewDidLoad **************************************************
	 *	initial set up of the view
	 **************************************************************************/
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (task.isRunning == 1.0) {	// This is compared to 1.0 cause Objective-C can't do booleans
            startAndStop.setTitle("Stop", forState: .Normal)
            startUITimer()
        }
        
        // set the delegate to self so the goalReached() alert shows up on this view controller
        task.delegate = self
        
        // hide the date picker and show the label, update labels
        goalDateDatePicker.hidden = true
        goalLabel.text = formatTime(Int(task.elapsedTime))
		timeCountLabel.text = formatTime(Int(task.elapsedTime))
		
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
    @IBAction func getTimeButtonSelected(sender: UIButton) {
        if (sender.titleLabel?.text == "Set Estimate") {
            // replace picker with label, change button, update labels
            goalLabel.text = formatTime(Int(task.elapsedTime) +
										Int(task.remainingTime))
            goalDateDatePicker.hidden = true
            goalLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
        } else {
            // replace label with picker, change button
            goalDateDatePicker.countDownDuration = Double(task.remainingTime) +
												   Double(task.elapsedTime)
            goalLabel.hidden = true
            goalDateDatePicker.hidden = false
            getEstimateButton.setTitle("Set Estimate", forState: .Normal)
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
        task.resetTimer()
		timeCountLabel.text = formatTime(Int(task.elapsedTime))
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
            self.goalLabel.text = formatTime(Int(sender.elapsedTime) + Int(sender.remainingTime))
            self.getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        })
        let stopAction = UIAlertAction(title: "Stop working", style: .Destructive, handler: {(alert: UIAlertAction!) in
            //TODO: dismiss estimateVC
            self.goalLabel.text = formatTime(Int(sender.elapsedTime) + Int(sender.remainingTime))
        })
        reachedGoalAlertController.addAction(addTimeAction)
        reachedGoalAlertController.addAction(stopAction)
        presentViewController(reachedGoalAlertController, animated: true, completion: nil)
    }
    
    // Changes the label of the timer
	func updateUI() {
        timeCountLabel.text = formatTime(Int(task.elapsedTime))
		let total = Int(task.elapsedTime) + Int(task.remainingTime)
		timeCountLabel.textColor = UIColor(red: (128 + (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, green: (240 - (240 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, blue: (128 - (128 / (CGFloat(total))) * CGFloat(task.elapsedTime)) / 255.0, alpha: 1.0)
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
