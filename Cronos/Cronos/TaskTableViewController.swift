//
//  TaskTableViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter and Cramer Smith and Tanner Fry. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var selectedTask: Task!
    var rightBarButton: UIBarButtonItem!
    
    var UITimer = NSTimer()
    
    // MARK - DEBUG
    let DEBUG = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        loadTasks()
        for task in tasks {
            if (task.isRunning.boolValue) {
                UITimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
            }
        }
        
        if (DEBUG && tasks.count == 0) {
            addTestTasks()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadTasks()
        self.tableView.reloadData()
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
    
    func updateUI() {
        loadTasks()
        tableView.reloadData()
    }
    
    func deleteAllSelector() {
        print("Deleting all tasks")
        deleteAllTasks()
        loadTasks()
        setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
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
    
    // MARK: - Core Data
    
    func addTestTasks() {
        let titles = ["Running", "Homework", "Programming"]
        let times = [Int](arrayLiteral: (1*60), (4*60), (7*60))
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
        if (task.isRunning.boolValue) { cell.startButton.setTitle("stop", forState: .Normal); cell.startButton.setTitleColor(UIColor.redColor(), forState: .Normal) }
        cell.taskName.text = task.name
        cell.timeActual.text = formatTime(Int(task.remainingTime))

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
        }
    }

}
