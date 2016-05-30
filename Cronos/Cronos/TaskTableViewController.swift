//
//  TaskTableViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter and Cramer Smith and Tanner Fry. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController, ModalDissmissDelegate {
    
    var selectedTask: Task!
    var rightBarButton: UIBarButtonItem!
    
    // MARK - DEBUG
    let DEBUG = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shows edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // load tasks
        loadTasks()
        
        // if we're testing and there are no tasks, load default tasks
        if (DEBUG && tasks.count == 0) {
            addTestTasks()
        }
    }
    
    // when view appears load tasks and reload table data
    override func viewWillAppear(animated: Bool) {
        loadTasks()
        self.tableView.reloadData()
    }
    
    func updateVC() {
        viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing == true) {
            rightBarButton = self.navigationItem.rightBarButtonItem
            let deleteAction = #selector(self.checkDeleteSelector)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .Done, target: self, action: deleteAction)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        } else {
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    // Delete's all tasks, probably just for testing purposes
    func deleteAllSelector() {
        print("Deleting all tasks")
        deleteAllTasks()
        loadTasks()
        setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    // check if the user really wants to delete all their tasks
    func checkDeleteSelector(sender: UIBarButtonItem) {
        print("checking delete")
        let checkDelete = UIAlertController(title: "Really?", message: "Are you sure you want to delete all your tasks?", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "I'm 100% sure!", style: .Destructive, handler: {(alert: UIAlertAction) in
            self.deleteAllSelector()
        })
        let noAction = UIAlertAction(title: "Hell no!", style: .Default, handler: nil)
        checkDelete.addAction(yesAction)
        checkDelete.addAction(noAction)
        presentViewController(checkDelete, animated: true, completion: nil)
    }
    
    // MARK: - Testing
    
    func addTestTasks() {
        let titles = ["Running", "Homework", "Programming", "ATesting"]
        let times = [Double](arrayLiteral: (1*60), (4*60), (7*60), 5)
        for i in 0..<titles.count {
            addTask(titles[i], goalTime: times[i])
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TimerTableViewCell
        let task = tasks[indexPath.row]
        
        cell.task = task
        cell.taskName.text = task.name
        cell.timeActual.text = formatTime(Int(task.elapsedTime))
        cell.task.delegate = cell
        if (task.isRunning.boolValue) {
            cell.startUITimer()
            cell.startButton.setTitle("stop", forState: .Normal)
            cell.startButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        } else {
            cell.startButton.setTitle("start", forState: .Normal)
            cell.startButton.setTitleColor(UIColor(red: 115/255, green: 204/255, blue: 0, alpha: 1.0), forState: .Normal)
            cell.stopUITimer()
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteTask(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let task = tasks[indexPath.row]
        selectedTask = task
        performSegueWithIdentifier("goalDetailSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goalDetailSegue") {
            let goalVC = segue.destinationViewController as! GoalDetailViewController
            goalVC.task = selectedTask
        } else if (segue.identifier == "addTaskSegue") {
            let addVC = segue.destinationViewController as! AddTaskViewController
            addVC.delegate = self
        }
    }

}
