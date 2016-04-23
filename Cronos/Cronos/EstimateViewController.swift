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

	var tasks = [Tasks]()
	
	var estimate:NSTimeInterval = 0.0

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
        estimateLabel.hidden = true
		timeCount.text = formatTime(counter)
		estimate = estimateTime.countDownDuration
		
		// Load estimate
		if let loadedTasks = loadTasks() {
			tasks = loadedTasks
			print(tasks)
		} else {
			loadSampleTask()
		}
		
		let task:Tasks = tasks[0]
		
		estimate = task.estimate
		counter = task.current
		
		estimateTime.countDownDuration = estimate
		print("This is \(task.task)")
		
    }
	
	func loadSampleTask(){
		let sampleCurrent = 120;
		let sampleTask = "Cooking"
		let sampleEsimate:NSTimeInterval = 360

		let task1 = Tasks(task: sampleTask, current: sampleCurrent, estimate: sampleEsimate)!
	
		tasks += [task1];
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
            estimate = estimateTime.countDownDuration
            estimateLabel.text = formatTime(Int(Double(estimate)))
            estimateTime.hidden = true
            estimateLabel.hidden = false
            getEstimateButton.setTitle("Edit Estimate", forState: .Normal)
        } else {
            estimateLabel.hidden = true
            estimateTime.hidden = false
            getEstimateButton.setTitle("Set Estimate", forState: .Normal)
        }
		
    }
	@IBAction func finishTaskAction(sender: UIButton) {
		stopTimer()
		startAndStop.setTitle("Start", forState: .Normal)
		
	}
	
	// This starts and stops the timer
	@IBAction func startTimer(sender: UIButton) {
		// TODO: Make this happen in a thread
		
		if (sender.titleLabel?.text == "Start") {
			estimate = estimateTime.countDownDuration
			timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
			                                               selector: #selector(timerAction),
			                                               userInfo: nil, repeats: true)
			// starts timer
			startAndStop.setTitle("Stop", forState: .Normal)
			timerAction()
			
			// change the reset button to function like a button
		} else if (sender.titleLabel?.text == "Stop") {
			// stops timer
			startAndStop.setTitle("Start", forState: .Normal)
			stopTimer()
		}
	}
	
	@IBAction func resetTimerAction(sender: UIButton) {
		resetTimer()
		timeCount.text = formatTime(counter)
		timeCount.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
		startAndStop.setTitle("Start", forState: .Normal)
	
		stopTimer()
	}

	// stops the timer and saves 
	func stopTimer() {
		timer.invalidate()
	}
	
	func resetTimer() {
		counter = 0;
		timeCount.text = formatTime(counter)
	}
	
	
	// MARK: Functions
	// Increments the timer and changes the label of the timer
	func timerAction() {
		counter += 1
		timeCount.text = formatTime(counter)
		//timeCount.textColor=UIColor(red: 100/255.0, green: 255 - (255 / CGFloat(counter))/255.0, blue: 255 - (255 / CGFloat(counter))/255.0, alpha: 1.0)
		
		timeCount.textColor=UIColor(red: (128 + (128 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, green: (128 - (128 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, blue: (128 - (128 / (CGFloat(estimate))) * CGFloat(counter)) / 255.0, alpha: 1.0)
		
		if (Double(counter) == estimate) {
			print("SHIT!")
			// TODO: Change color of timer
			timeCount.textColor = UIColor.redColor()
			
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
	
	// MARK: NSCoding 
	
	func saveTasks() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Tasks.ArchiveURL.path!)
		if !isSuccessfulSave {
			print("Failed to save task(s)...")
		}
	}
	
	func loadTasks() -> [Tasks]? {
		return NSKeyedUnarchiver.unarchiveObjectWithFile(Tasks.ArchiveURL.path!) as? [Tasks]
	}
	

}
