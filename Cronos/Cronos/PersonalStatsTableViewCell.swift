//
//  PersonalStatsTableViewCell.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 6/7/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class PersonalStatsTableViewCell: UITableViewCell {

    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var attemptedLabel: UILabel!
    @IBOutlet var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
