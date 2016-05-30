//
//  EditTaskViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 5/30/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    var task: Task!
    var delegate: ModalDissmissDelegate?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var goalDatePicker: UIDatePicker!
    @IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.navBar.topItem?.title = "Edit \(self.task.name)"
        self.nameTextField.placeholder = self.task.name
        self.goalDatePicker.countDownDuration = Double(self.task.goalTime)
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        let resetCheckAlert = UIAlertController(title: "Are you sure?", message: "This will reset all progress you've made on this task since you created it.", preferredStyle: .ActionSheet)
        let sureAction = UIAlertAction(title: "I'm 100% sure I want to get rid of all progress", style: .Destructive) { (alert) in
            self.task.resetTimer()
        }
        let unsureAction = UIAlertAction(title: "I don't want to do this", style: .Default, handler: nil)
        resetCheckAlert.addAction(sureAction)
        resetCheckAlert.addAction(unsureAction)
        presentViewController(resetCheckAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) {
            if (self.nameTextField.text != "" && self.nameTextField.text != nil) {
                self.task.name = self.nameTextField.text
            }
            self.task.goalTime = self.goalDatePicker.countDownDuration
            save()
            self.delegate?.updateVC()
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
