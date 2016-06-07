//
//  StatsViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 6/6/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet var responseTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonSelected(sender: UIBarButtonItem) {
        postUpdatedStats()
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
