//
//  StatsViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 6/7/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, TaskDelegate {

    @IBOutlet var attemptedLabel: UILabel!
    @IBOutlet var completedLabel: UILabel!
    
    override func viewDidLoad() {
		UISetup()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        getStats()
    }
    
    func getStats() {
        let url = "http://cronos-1329.appspot.com/cronosServlet?op=stats"
        get(url) { (succeeded, msg) in
            if (succeeded) {
                print("Success")
                let attempted = msg["Attempted"]
                let completed = msg["Completed"]
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.attemptedLabel.text = String(attempted!)
                    self.completedLabel.text = String(completed!)
                })
            } else {
                print("Failed")
            }
        }
    }
    
    func stopUITimer() {}
    func goalReached() {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
