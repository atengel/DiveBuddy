//
//  ExamineDiveTableViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/1/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import Social

class ExamineDiveTableViewController: UITableViewController {
    let numSections = 4
    let sectionRowCounts = [3,4,1,1]
    
    //uilabels for dive information
    @IBOutlet weak var dateAndDiveSiteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var buddyLabel: UILabel!
    @IBOutlet weak var weatherAndTempLabel: UILabel!
    @IBOutlet weak var waterTempAndVizLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var maxDepthLabel: UILabel!
    @IBOutlet weak var tankTypeAndVolumeLabel: UILabel!
    @IBOutlet weak var airTypeLabel: UILabel!
    @IBOutlet weak var startPsiLabel: UILabel!
    @IBOutlet weak var endPsiLabel: UILabel!
    @IBOutlet weak var diveNotesLabel: UILabel!
    
    //dive used to populate labels
    var dive: DiveInfo?
    
    //array of coredata images to be displayed in the collection view at the bottom of the table view
    private var diveImages: [Image]?
    
    //user clicks options button
    @IBAction func shareDive(sender: UIBarButtonItem) {
        
        //alert controller pops up to give user sharing options
        let shareActions = UIAlertController(title: "", message: "Options", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //twitter sharing option
        let twitter = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) {(action) -> Void in
            // Check if sharing to Twitter is possible.
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                //template text for tweet
                twitterComposeVC.setInitialText("I just went diving in " + self.dive!.dive_site! + ". I reached a max depth of " + String(self.dive!.max_depth!) + "ft and was underwater for " + String(self.dive!.duration!) + " minutes.");
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
        }
        
        //facebook sharing option
        let facebook = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) {(action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                //template text for post
                facebookComposeVC.setInitialText("I just went diving in " + self.dive!.dive_site! + ". I reached a max depth of " + String(self.dive!.max_depth!) + "ft and was underwater for " + String(self.dive!.duration!) + " minutes.");
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not connected to your Facebook account.")
            }
            
        }
        
        //edit option to transition to a view where you can edit the dive
        let edit = UIAlertAction(title: "Edit Dive", style: UIAlertActionStyle.Default) {(action) -> Void in
            self.performSegueWithIdentifier("editSegue", sender: self)
        }
        
        //more launches an activity view controller with the default additional activies such as sharing via email, messenger, etc
        let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
            var diveText = "I just went diving in " + self.dive!.dive_site!
                diveText += ". I reached a max depth of " + String(self.dive!.max_depth!) + "ft and was underwater for "
                diveText += String(self.dive!.duration!) + " minutes.)"
            
            let activityViewController = UIActivityViewController(activityItems: [diveText], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        //close the alert view controller
        let dismiss = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        //populate the alertviewcontroller
        shareActions.addAction(twitter)
        shareActions.addAction(facebook)
        shareActions.addAction(edit)
        shareActions.addAction(moreAction)
        shareActions.addAction(dismiss)
        presentViewController(shareActions, animated: true, completion: nil)

    }
    //display messge to the user
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "Dive Buddy", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //use the data from the dive to populate labels
    func populateDatafields() {
        //check settings to see if labels should be imperial or metric
        let defaults = NSUserDefaults.standardUserDefaults()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate((dive!.date)!)
        let diveSite = dive!.dive_site!
        dateAndDiveSiteLabel.text = diveSite + ", " + dateString
        if(dive!.buddy != nil) {
            buddyLabel.text = dive!.buddy!
        }
        if(dive!.weather != nil || dive!.air_temp != nil) {
            var text = ""
            if(dive!.weather != nil) {
                text = dive!.weather! + ", "
            }
            if(dive!.air_temp != 0) {
                if defaults.boolForKey("metric") {
                    text += String(dive!.air_temp!) + "°C"
                } else {
                    text += String(dive!.air_temp!) + "°F"
                }
            }
            weatherAndTempLabel.text = text
        }
        if(dive!.water_temp! != 0 || dive!.visibility! != 0) {
            var text = ""
            if(dive!.water_temp != 0) {
                if defaults.boolForKey("metric") {
                    text = String(dive!.water_temp!) + "°C, "
                } else {
                    text = String(dive!.water_temp!) + "°F, "
                }
            }
            if(dive!.visibility != 0) {
                if defaults.boolForKey("metric") {
                    text += String(dive!.visibility!) + " m"
                } else {
                    text += String(dive!.visibility!) + " ft"
                }
            }
            waterTempAndVizLabel.text = text
        }
        if(dive!.start_time != nil) {
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            startTimeLabel.text = dateFormatter.stringFromDate(dive!.start_time!)
        }
        if(dive!.duration != 0) {
            durationLabel.text = String(dive!.duration!) + " min."
        }
        if(dive!.end_time != nil) {
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            endTimeLabel.text = dateFormatter.stringFromDate(dive!.end_time!)
        }
        if(dive!.max_depth != 0) {
            if defaults.boolForKey("metric") {
                maxDepthLabel.text = String(dive!.max_depth!) + " m"
            } else {
                maxDepthLabel.text = String(dive!.max_depth!) + " ft"
            }
        }
        if(dive!.tank_type != nil || dive!.tank_volume != 0) {
            var text = ""
            if(dive!.tank_type != nil) {
                text = String(dive!.tank_type!) + ", "
            }
            if(dive!.tank_volume != 0) {
                if defaults.boolForKey("metric") {
                    text += String(dive!.tank_volume!) + "L"
                } else {
                    text += String(dive!.tank_volume!) + " cu. ft."
                }
            }
            tankTypeAndVolumeLabel.text = text
        }
        if(dive!.air_type != nil) {
            airTypeLabel.text = dive!.air_type!
        }
        if(dive!.start_psi != 0) {
            if defaults.boolForKey("metric") {
                startPsiLabel.text = String(dive!.start_psi!) + " bar"
            } else {
                startPsiLabel.text = String(dive!.start_psi!) + " psi"
            }
        }
        if(dive!.end_psi != 0) {
            if defaults.boolForKey("metric") {
                endPsiLabel.text = String(dive!.start_psi!) + " bar"
            } else {
                endPsiLabel.text = String(dive!.end_psi!) + " psi"
            }
        }
        if(dive!.notes != nil) {
            diveNotesLabel.text = dive!.notes!
        }
        
        //populate diveimages so collection view will show photos
        if(dive!.images != nil) {
            diveImages = dive!.images!.array as? [Image]
        }
        if(dive!.location != nil) {
            locationLabel.text = dive!.location!
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        populateDatafields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDatafields()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionRowCounts[section]
    }
    
    //Handle condition for the cell that contains the collection view
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let photoTableViewCell = cell as? PhotoTableViewCell else { return }
        
        photoTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {return}
        switch identifier {
        case "editSegue":
            guard let destination = segue.destinationViewController as? NewDiveTableViewController else {return}
            destination.existingDive = dive
        case "InspectImage":
            let destination = segue.destinationViewController as? InspectImageViewController
            let sendingCell = sender as? UploadPhotoViewCell
            destination!.image = sendingCell!.imageView?.image
        default:
            return
        }
    }

}
extension ExamineDiveTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return diveImages!.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        willDisplayCell cell: UICollectionViewCell,
                                        forItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = cell as? UploadPhotoViewCell {
            photoCell.imageView.image = UIImage(data: diveImages![indexPath.row].image_data!)
            photoCell.contentMode = .ScaleAspectFit
        }
        
    }
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell",
                                                                         forIndexPath: indexPath)
        return cell
    }
}
