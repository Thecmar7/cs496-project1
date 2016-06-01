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
    
    var delegate: ModalDissmissDelegate?
    
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
		//var name = self.nameTextField.text;
		if (self.nameTextField!.text!.isEmpty) {
			let alertController = UIAlertController(title: "Name?", message: "Please input a name for your new task:", preferredStyle: .Alert)
			
			let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
				if let field = alertController.textFields?[0] {
			
					// store your data
					self.nameTextField.text = field.text!
				} else {
					// user did not fill field
                    self.dismissViewControllerAnimated(true, completion: nil)
				}
			}

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

			alertController.addTextFieldWithConfigurationHandler { (textField) in
				textField.placeholder = "Task name"
			}

			alertController.addAction(confirmAction)
			alertController.addAction(cancelAction)

			self.presentViewController(alertController, animated: true, completion: nil)
			
			
		} else {
			dismissViewControllerAnimated(true) {
				addTask(self.nameTextField.text!, goalTime: self.estimateDatePicker.countDownDuration)
                self.delegate?.updateVC()
			}
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
