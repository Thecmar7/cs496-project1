//
//  AddTaskViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/24/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var estimateDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) { 
            addTask(self.nameTextField.text!, estimate: Int(self.estimateDatePicker.countDownDuration))
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
