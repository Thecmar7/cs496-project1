//
//  EstimateViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit
import Foundation

class EstimateViewController: UIViewController {
	
    var task: Task!
    
    var estimate: Int!
    var current: Int!
    var name: String!

	var counter = 0
	var timer = NSTimer()
	
    @IBOutlet var estimateTime: UIDatePicker!
	@IBOutlet weak var timeCount: UILabel!
    @IBOutlet var estimateLabel: UILabel!
    
	//@IBOutlet weak var startAndStop: UIButton!
	@IBOutlet weak var reset: UIButton!
	@IBOutlet var startAndStop: UIButton!
    @IBOutlet var getEstimateButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        counter = current
        estimateTime.hidden = true
        estimateLabel.text = formatTime(estimate)
		timeCount.text = formatTime(counter)
        self.title = name
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	//  This is a test function for the selector wheel
    @IBAction func getTimeButtonSelected(sender: UIButton) {
        
        if (sender.titleLabel?.text == "Set Estimate") {
            // replace picker with label and change button
            estimate = Int(estimateTime.countDownDuration)
            updateTask(task, value: estimate, key: "estimateTime")
            estimateLabel.text = formatTime(estimate)
            estimateTime.hidden = true
            estimateLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
        } else {
            estimateTime.countDownDuration = Double(estimate!)
            estimateLabel.hidden = true
            estimateTime.hidden = false
            getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        }
		
    }
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
        //TODO: Archive Task
        print("Archive Task")
	}
	
	// This starts and stops the timer
	@IBAction func startTimer(sender: UIButton) {
		// TODO: Make this happen in a thread
		
		if (sender.titleLabel?.text == "Start") {
            
            if (counter >= estimate) {
                let alert = UIAlertController(title: "Uh Oh!", message: "Please set a new goal!", preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "I'm on it!", style: .Default, handler: { (alert: UIAlertAction) in
                    self.estimateTime.hidden = false
                    self.estimateLabel.hidden = true
                    self.getEstimateButton.setTitle("Set Estimate", forState: .Normal)
                })
                alert.addAction(okayAction)
                presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            estimateTime.hidden = true
            estimateLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
            
            // starts timer
//			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            task.startTimer()
			startAndStop.setTitle("Stop", forState: .Normal)
            
			// change the reset button to function like a button
		} else if (sender.titleLabel?.text == "Stop") {
			// stops timer
			stopTimer()
		}
	}
	
	@IBAction func resetTimerAction(sender: UIButton) {
		resetTimer()
		timeCount.text = formatTime(counter)
		timeCount.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
	
		stopTimer()
	}

	// stops the timer and saves 
	func stopTimer() {
		task.stopTimer()
        startAndStop.setTitle("Start", forState: .Normal)
        //updateTask(self.task, value: counter, key: "currentTime")
	}
	
	func resetTimer() {
		counter = 0;
		timeCount.text = formatTime(counter)
	}
	
	
	// MARK: Functions
	// Increments the timer and changes the label of the timer
	func timerAction() {
		timeCount.text = formatTime(counter)
		//timeCount.textColor=UIColor(red: 100/255.0, green: 255 - (255 / CGFloat(counter))/255.0, blue: 255 - (255 / CGFloat(counter))/255.0, alpha: 1.0)
		
		timeCount.textColor = UIColor(red: (128 + (128 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, green: (240 - (240 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, blue: (128 - (128 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, alpha: 1.0)
		
		if (Double(counter) >= Double(estimate)) {
			// TODO: Change color of timer
			timeCount.textColor = UIColor.redColor()
            stopTimer()
			let reachedGoalAlertController = UIAlertController(title: "You did it!", message: "You reached your goal! Do you want to keep going or would you like to stop?", preferredStyle: .Alert)
            let addTimeAction = UIAlertAction(title: "Set new goal and keep going!", style: .Default, handler: {(alert: UIAlertAction!) in
                self.estimateTime.hidden = false
                self.estimateLabel.hidden = true
                self.getEstimateButton.setTitle("Set Estimate", forState: .Normal)
            })
            let stopAction = UIAlertAction(title: "Stop working", style: .Destructive, handler: {(alert: UIAlertAction!) in
                self.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
            })
            reachedGoalAlertController.addAction(addTimeAction)
            reachedGoalAlertController.addAction(stopAction)
            presentViewController(reachedGoalAlertController, animated: true, completion: nil)
		}
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
