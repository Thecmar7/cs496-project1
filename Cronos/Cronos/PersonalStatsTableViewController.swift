//
//  PersonalStatsTableViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 6/7/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class PersonalStatsTableViewController: UITableViewController {
    
    var stats = [Dictionary<String, Int>]()
    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getStats()
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        getStats()
    }
    
    func getStats() {
        stats.removeAll()
        names.removeAll()
        for task in tasks {
            let originalName = task.name
            let name = originalName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            let url = "http://cronos-1329.appspot.com/cronosServlet?op=taskStats&id=\(uuid)&name=\(name!)"
            print(url)
            get(url, getCompleted: { (succeeded, msg) in
                if (succeeded) {
                    print("Success")
                    print(msg)
                    print(self.names)
                    self.stats.append(msg)
                    self.names.append(originalName)
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.tableView.reloadData()
                    })
                } else {
                    print("Failure")
                }
            })
        }
        print(stats)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stats.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PersonalStatsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("statsCell", forIndexPath: indexPath) as! PersonalStatsTableViewCell
        cell.taskNameLabel.text = String(names[indexPath.row])
        cell.attemptedLabel.text = String(stats[indexPath.row]["Attempted"]!)
        cell.completedLabel.text = String(stats[indexPath.row]["Completed"]!)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
