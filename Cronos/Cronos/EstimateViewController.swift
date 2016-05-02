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
    
	var UItimer = NSTimer()
	
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
        if (task.isRunning) {
            startAndStop.setTitle("Stop", forState: .Normal)
        }
        
        estimateTime.hidden = true
        estimateLabel.text = formatTime(Int(task.estimateTime))
		timeCount.text = formatTime(Int(task.currentTime))
        estimateTime.countDownDuration = NSTimeInterval(task.estimateTime)
        self.title = task.name
        
        
        UItimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
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
            task.estimateTime = Int(estimateTime.countDownDuration)
            //updateTask(task, value: estimate, key: "estimateTime")
            estimateLabel.text = formatTime(Int(task.estimateTime))
            estimateTime.hidden = true
            estimateLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
        } else {
            estimateTime.countDownDuration = Double(Int(task.estimateTime))
            estimateLabel.hidden = true
            estimateTime.hidden = false
            getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        }
		
    }
    
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
        
	}
	
	// This starts and stops the timer
	@IBAction func startTimer(sender: UIButton) {
		// TODO: Make this happen in a thread
        UItimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: true)

		if (sender.titleLabel?.text == "Start") {
            
            if (task.counter >= Int(task.estimateTime)) {
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
		timeCount.text = formatTime(Int(task.currentTime))
		timeCount.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
	
		stopTimer()
	}

    // MARK: Functions
    func resetTimer() {
		task.currentTime = 0
		timeCount.text = formatTime(Int(task.currentTime))
	}

	// stops the timer and saves 
	func stopTimer() {
        UItimer.invalidate()
        
		task.stopTimer()
        startAndStop.setTitle("Start", forState: .Normal)
        //updateTask(self.task, value: counter, key: "currentTime")
	}
	
    func timerSelector() {
        updateUI()
        //if (task.isRunning) {
            checkGoal()
        //}
        
    }
    
    // Increments the timer and changes the label of the timer
	func updateUI() {
		
        timeCount.text = formatTime(Int(task.currentTime))
        
		timeCount.textColor = UIColor(red: (128 + (128 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, green: (240 - (240 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, blue: (128 - (128 / (CGFloat(task.estimateTime))) * CGFloat(task.currentTime)) / 255.0, alpha: 1.0)
        
	}
    
    func checkGoal() {
        if (Double(task.counter) >= Double(task.estimateTime)) {
            timeCount.textColor = UIColor.redColor()
            stopTimer()
            let reachedGoalAlertController = UIAlertController(title: "You did it!", message: "You reached your goal! Do you want to keep going or would you like to stop?", preferredStyle: .Alert)
            let addTimeAction = UIAlertAction(title: "Set new goal and keep going!", style: .Default, handler: {(alert: UIAlertAction!) in
                self.estimateTime.hidden = false
                self.estimateLabel.hidden = true
                self.estimateLabel.text = formatTime(Int(self.task.estimateTime))
                //updateTask(self.task, value: self.task.estimateTime, key: "estimateTime")
                self.getEstimateButton.setTitle("Set Estimate", forState: .Normal)
            })
            let stopAction = UIAlertAction(title: "Stop working", style: .Destructive, handler: {(alert: UIAlertAction!) in
                //TODO: dismiss estimateVC
                self.estimateLabel.text = formatTime(Int(self.task.estimateTime))
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
