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

	var estimate:NSTimeInterval = 0.0
	
	var counter = 0
	var timer = NSTimer()
	
    @IBOutlet var estimateTime: UIDatePicker!
	@IBOutlet weak var timeCount: UILabel!
    
	//@IBOutlet weak var startAndStop: UIButton!
	@IBOutlet weak var reset: UIButton!
	@IBOutlet var startAndStop: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		timeCount.text = formatTime(counter)
		estimate = estimateTime.countDownDuration
    }

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	//  This is a test function for the selector wheel
    @IBAction func getTimeButtonSelected(sender: UIButton) {
        print(estimateTime.countDownDuration)
    }
	
	// This starts and stops the timer
	@IBAction func startTimer(sender: UIButton) {
        
        print("timer started")
		if (sender.titleLabel?.text == "Start") {
			print("The Label is start")
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
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
	
	// changes the seconds to hour, minute, seconds
	func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
		return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
	}
	
	func formatTime(time: Int) -> String {
		let (h, m, s) = secondsToHoursMinutesSeconds(time)
		return String(format: "%02d:%02d:%02d", h, m, s)
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
