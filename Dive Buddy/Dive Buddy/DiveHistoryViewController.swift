//
//  DiveHistoryViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/27/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import CoreData

class DiveHistoryViewController: CoreDataTableViewController {
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrieve all dives from coredata using fetched results controller
        if let context = managedObjectContext {
            let request = NSFetchRequest(entityName: "DiveInfo")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
        // Do any additional setup after loading the view.
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
        return (fetchedResultsController?.fetchedObjects?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiveInfoCell", forIndexPath: indexPath)
        //for each dive, populate the fields of the table view cell with the dive information and first photo
        if let dive = fetchedResultsController?.objectAtIndexPath(indexPath) as? DiveInfo {
            var date: NSDate?
            var site: String?
            var location: String?
            var imageData: NSData?
            
            //capture information from the dive
            dive.managedObjectContext?.performBlockAndWait {
                date = dive.date
                site = dive.dive_site
                location = dive.location
                if let image = dive.images?.firstObject as? Image {
                    imageData = image.image_data
                }
   
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            if let diveCell = cell as? DiveTableViewCell {
                diveCell.diveSiteLabel.text! = site!
                diveCell.diveDateLabel.text! = dateFormatter.stringFromDate(date!)
                if location != nil {
                    diveCell.diveDescriptionLabel.text! = location!
                }
                if imageData != nil {
                diveCell.diveImageView.image = UIImage(data: imageData!)
                
                }
                diveCell.dive = dive
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //delete cells from table
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            
            // remove the deleted item from the mode
            managedObjectContext!.deleteObject((fetchedResultsController?.objectAtIndexPath(indexPath))! as! NSManagedObject)
            do {
                try managedObjectContext!.save()
            } catch _ {
            }
            
            // remove the deleted item from the `UITableView`
            self.tableView.reloadData()
        default:
            return
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExamineDiveSegue" {
            guard let destination = segue.destinationViewController as? ExamineDiveTableViewController else { return }
            guard let dive = (sender as? DiveTableViewCell)?.dive else { return }
            
            destination.dive = dive
            print(dive)
        }
    }

}
