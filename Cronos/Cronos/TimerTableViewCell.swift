//
//  TimerTableViewCell.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    @IBOutlet var taskName: UILabel!
    @IBOutlet var timeActual: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var task: Task!
    var timer = NSTimer()
    var counter = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func startButton(sender: UIButton) {        
        if (task.isRunning.boolValue) {
            task.stopTimer()
            startButton.setTitle("start", forState: .Normal)
            startButton.setTitleColor(UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0), forState: .Normal)
            timer.invalidate()
        } else {
            task.startTimer()
            counter = Int(task.elapsedTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
            startButton.setTitle("stop", forState: .Normal)
            startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
    }
    
    func updateUI() {
        counter += 1
        timeActual.text = formatTime(counter)
    }
}
