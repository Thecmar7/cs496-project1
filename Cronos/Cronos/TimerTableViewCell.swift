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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func startButton(sender: UIButton) {
        //TODO: async
        
        if (task.isRunning == false) {
            task.startTimer()
            startButton.setTitle("stop", forState: .Normal)
        } else {
            task.stopTimer()
            startButton.setTitle("start", forState: .Normal)
        }
    }
}
