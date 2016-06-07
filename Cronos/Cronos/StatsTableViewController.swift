//
//  StatsTableViewController.swift
//  Cronos
//
//  Created by Samuel Lichlyter on 6/7/16.
//  Copyright © 2016 Samuel Lichlyter. All rights reserved.
//

import UIKit

class StatsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getStats()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        getStats()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    // MARK: - Network Functions
    
    func postUpdatedStats() {
        //    let uuid = NSUUID().UUIDString
        let url = "http://localhost:8888?id=7"
        let data = "DATA"
        postNetworkRequest(url, data: data)
    }
    
    func postNewTask(task: Task) {
        let name = task.name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url = "http://localhost:8888/cronosServlet?op=new&id=1&name=\(name!)"
        print(url)
        postNetworkRequest(url, data: nil)
    }
    
    func getStats() {
        let name = tasks[0].name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url = "http://cronos-1329.appspot.com/cronosServlet?id=1&name=\(name!)"
        getNetworkRequest(url)
    }
    
    func postNetworkRequest(url: String, data: String?) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let bodyData = data
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData?.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        }
        task.resume()
    }
    
    func getNetworkRequest(url: String) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "GET"
        request.HTTPBody = nil
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                    print("Success")
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            print(json)
                        }
                    } catch let error as NSError {
                        print("Unresolved error \(error), \(error.userInfo)")
                    }
                } else {
                    print("Failure")
                }
            }
        }
        task.resume()
    }


}
