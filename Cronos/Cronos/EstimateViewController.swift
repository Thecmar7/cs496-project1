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

	var counter = 0
	var timer = NSTimer()
	
	enum state {
		case go
		case stop
	}
	
    @IBOutlet var estimateTime: UIDatePicker!
	@IBOutlet weak var timeCount: UILabel!
    
	//@IBOutlet weak var startAndStop: UIButton!
	@IBOutlet weak var reset: UIButton!
	@IBOutlet var startAndStop: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
    @IBAction func getTimeButtonSelected(sender: UIButton) {
        print(estimateTime.countDownDuration)
    }
	
	@IBAction func startTimer(sender: UIButton) {
        
        print("timer started")
		if (sender.titleLabel?.text == "Start") {
			print("The Label is start")
			timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
			// starts timer
			startAndStop.setTitle("Stop", forState: .Normal)
			timerAction()
			
			// change the reset button to function like a button
		} else if (sender.titleLabel?.text == "Stop") {
			// stops timer
			startAndStop.setTitle("Start", forState: .Normal)
			timer.invalidate()
		}
	}

	
	func timerAction() {
		counter += 1
		let (h, m, s) = secondsToHoursMinutesSeconds(counter)
		timeCount.text = String(format: "%02d:%02d:%02d", h, m, s)
		
		
		if (Double(counter) == estimateTime.countDownDuration) {
			print("SHIT!")
			
		}
	}
	
	func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
		return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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
