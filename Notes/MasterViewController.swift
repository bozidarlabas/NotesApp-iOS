//
//  MasterViewController.swift
//  Notes
//
//  Created by Bozidar on 17.12.2015..
//  Copyright © 2015. Bozidar. All rights reserved.
//

import UIKit

var objects = [String]()
var currentIndex: Int = 0
var masterView: MasterViewController?
var detailViewController: DetailViewController?
let keyNotes = "notes"
let BLANK_NOTE: String = "(New Note)"

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        load()
        //adding Done button in navigation
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //Adding action "insertNewObject" which is inside this (self) class
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //adding + button in inavigation
        self.navigationItem.rightBarButtonItem = addButton
    }

    //this is called when navigating from detail view to master view
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        save()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        if objects.count == 0{
            insertNewObject(self)
        }
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        if objects.count == 0 || objects[0] != BLANK_NOTE{
            objects.insert(BLANK_NOTE, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

        currentIndex = 0
        self.performSegueWithIdentifier("showDetail", sender: self)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                currentIndex = indexPath.row
                
                detailViewController?.detailItem = object
                detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func save(){
        //save data to persistent storage
        NSUserDefaults.standardUserDefaults().setObject(objects, forKey: keyNotes)
        //save data instant
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func load(){
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(keyNotes) as? [String]{
            objects = loadedData
        }
        
    }


}

