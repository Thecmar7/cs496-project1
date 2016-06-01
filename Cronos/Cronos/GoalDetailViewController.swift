//
//  GoalDetailViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController, TaskDelegate, ModalDissmissDelegate {
	// The task
    var task: Task!
	
	// the timer to update the UI
	var UItimer = NSTimer()
    var UIcounter: Int!
	
	/***** MARK: UIInteractables **********************************************/
	@IBOutlet var startAndStopButton: UIButton!
	
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
	
	/***************************************************************************
	*	viewWillAppear
	*		initial UI set up of the view
	**************************************************************************/
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// set up the button to show the correct text
		if (task.checkIfIsRunning()) {
			startUITimer()
			startAndStopButton.setTitle("Stop", forState: .Normal)
		} else {
			startAndStopButton.setTitle("Start", forState: .Normal)
		}
		
		// delegate stuff I don't understand -Cramer
		task.delegate = self
		
		// Set button text and color
		if (task.isRunning.boolValue) {
			startAndStopButton.setTitle("Stop", forState: .Normal)
			startAndStopButton.backgroundColor = UIColor.redColor()
			startUITimer()
		}
		
		// set the goal label
		goalLabel.text = formatTime(Int(task.goalTime))
		
		// set title to task name
		self.title = task.name
		
		elapsedTimeLabel.text = formatTime(Int(task.getViewTime()))
		
	}
    
    func updateVC() {
        viewWillAppear(true)
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
	 *	startTimer
	 *		This starts and stops the timer
	 **************************************************************************/
	@IBAction func startTimer(sender: UIButton) {
		if (startAndStopButton.titleLabel!.text! == "Start") {
			//start updating the UI as often as the timer updates
			startUITimer()
			task.startTimer()
			
			// change label
			startAndStopButton.setTitle("Stop", forState: .Normal)
		} else {
			// stops timer
			stopUITimer()
		}
	}
	
	// MARK: UITimer
	/***************************************************************************
	*	startUITimer
	*		update the UI every time the task updates
	**************************************************************************/
	func startUITimer() {
		UItimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
		                                                 target: self,
		                                                 selector: #selector(updateUI),
		                                                 userInfo: nil,
		                                                 repeats: true)
		NSRunLoop.mainRunLoop().addTimer(UItimer, forMode: NSDefaultRunLoopMode)
	}
	
	/***************************************************************************
	*	stopUITimer
	*		update the UI every time the task updates
	**************************************************************************/
	func stopUITimer() {
		UItimer.invalidate()
		if (task.checkIfIsRunning()) {
			task.stopTimer()
		}
		startAndStopButton.setTitle("Start", forState: .Normal)
		startAndStopButton.backgroundColor = RGBColor(0.0, g: 200.0, b: 0.0)
	}
	
	/***************************************************************************
	*	goalReached
	*		Sets elapsed time label to the goal time
	*		Delegate calls this
	**************************************************************************/
	func goalReached() {
		elapsedTimeLabel.text = formatTime(Int(task.goalTime))
	}
	
	
	/**************************************************************************
	 *	updateUI
	 *		Changes the label of the timer
	 **************************************************************************/
	func updateUI() {
		elapsedTimeLabel.text = formatTime(Int(task.getViewTime()))
		elapsedTimeLabel.textColor = RGBColor(0.0, g: 0.0, b: 0.0)
	}
	
	
	/**************************************************************************
	*	RGBColor
	*		a function to make the changing of color a bit simpler
	**************************************************************************/
	func RGBColor(r:Double, g:Double, b:Double) -> UIColor {
		/* return UIColor(red: (0 + (256 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0,
		green: (240 - (240 / ((CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime)))/2) / 255.0,
		blue: (128 - (128 / (CGFloat(task.goalTime))) * (CGFloat(UIcounter) + CGFloat(task.elapsedTime))) / 255.0,
		alpha: 1.0) */
		return UIColor(red:	  (CGFloat(r) / 255.0),
		               green: (CGFloat(g) / 255.0),
		               blue:  (CGFloat(b) / 255.0),
		               alpha: 1.0)
	}
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "edit segue") {
            let editVC = segue.destinationViewController as! EditTaskViewController
            editVC.task = self.task
            editVC.delegate = self
        }
    }
	
}
