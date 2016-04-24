//
//  TaskTableViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 4/20/16.
//  Copyright © 2016 Samuel Lichlyter and Cramer Smith and Tanner Fry. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {
    
    var selectedTask: Task!
    var selectedTitle: String!
    var selectedEstimate: Int!
    var selectedCurrent: Int!
    
    var rightBarButton: UIBarButtonItem!
    
    // MARK - DEBUG
    let DEBUG = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        loadTasks()
        
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
            let deleteAction = #selector(self.deleteAllSelector)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: UIBarButtonItemStyle.Done, target: self, action: deleteAction)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        } else {
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
    }
    
    func deleteAllSelector(sender: UIBarButtonItem!) {
        print("Deleting all tasks")
        deleteAllTasks()
        loadTasks()
        setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    // MARK: - Core Data
    
    func addTestTasks() {
        let titles = ["Running", "Homework", "Programming"]
        let times = [Int](arrayLiteral: (2*3600), (4*3600), (7*3600))
        for i in 0..<titles.count {
            addTask(titles[i], estimate: times[i])
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
        let nameString = task.valueForKey("name") as? String
        let actualTimeInt = task.valueForKey("currentTime") as? Int
        
        cell.taskName.text = nameString
        cell.timeActual.text = formatTime(actualTimeInt!)

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
            deleteTask(indexPath.row)
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
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TimerTableViewCell
        let task = tasks[indexPath.row]
        selectedTask = task as? Task
        selectedTitle = task.valueForKey("name") as? String
        selectedEstimate = task.valueForKey("estimateTime") as? Int
        selectedCurrent = task.valueForKey("currentTime") as? Int
        performSegueWithIdentifier("estimateSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "estimateSegue") {
            let estimateVC = segue.destinationViewController as! EstimateViewController
            estimateVC.task = selectedTask
            estimateVC.current = selectedCurrent
            estimateVC.estimate = selectedEstimate
            estimateVC.name = selectedTitle
        }
    }

}
