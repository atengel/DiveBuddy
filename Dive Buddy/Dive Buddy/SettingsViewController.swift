//
//  SettingsViewController.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/5/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    //hardcoded dives
    private var dive1:[String: String?] = ["date": "Jun 7, 2016", "buddy": "Austin", "dive_site": "Point Lobos", "location": "Monterey, CA", "weather": "Sunny", "air_temp": "72", "water_temp": "55", "visibility": "15", "start_time": "9:30 AM", "end_time": "10:15 AM", "max_depth": "65", "tank_type": "Steel", "tank_vol": "100", "air_type": "Nitrox", "start_psi": "3200", "end_psi": "500", "notes": "Great dive! Saw lots of seals in the kelp forests."]
    private var dive2:[String: String?] = ["date": "Jun 1, 2016", "buddy": "Austin", "dive_site": "Monastery", "location": "Monterey, CA", "weather": "Cloudy", "air_temp": "72", "water_temp": "50", "visibility": "20", "start_time": "10:30 AM", "end_time": "11:30 AM", "max_depth": "70", "tank_type": "Aluminum", "tank_vol": "80", "air_type": "Regular", "start_psi": "3000", "end_psi": "500", "notes": "Great dive! Saw a bunch of nudibranchs."]
    private var dive3:[String: String?] = ["date": "May 25, 2016", "buddy": "Trevor", "dive_site": "Cove 2", "location": "Alki Beach, WA", "weather": "Windy", "air_temp": "50", "water_temp": "50", "visibility": "10", "start_time": "8:30 PM", "end_time": "10:00 PM", "max_depth": "80", "tank_type": "Steel", "tank_vol": "100", "air_type": "Regular", "start_psi": "3500", "end_psi": "400", "notes": "Water was murky but we saw an octopus!"]
    private var dive4:[String: String?] = ["date": "May 23, 2016", "buddy": "Trevor", "dive_site": "Breakwater", "location": "Monterey, CA", "weather": "Cold and windy", "air_temp": "40", "water_temp": "45", "visibility": "24", "start_time": "8:30 AM", "end_time": "9:45 AM", "max_depth": "40", "tank_type": "Steel", "tank_vol": "80", "air_type": "Nitrox", "start_psi": "3000", "end_psi": "400", "notes": "Tons of starfish and sea cucumbers."]
    private var dive5:[String: String?] = ["date": "May 20, 2016", "buddy": "Fiona", "dive_site": "Breakwater", "location": "Monterey, CA", "weather": "Sunny", "air_temp": "80", "water_temp": "55", "visibility": "30", "start_time": "11:30 AM", "end_time": "12:30 PM", "max_depth": "30", "tank_type": "Steel", "tank_vol": "100", "air_type": "Regular", "start_psi": "2900", "end_psi": "400", "notes": "Tons of starfish and sea cucumbers."]
    
    //load hardcoded dives into coredata
    @IBAction func loadData(sender: AnyObject) {
        DiveInfo.diveInfoFromDictionary(dive1, imageDatum: [NSData](), updateObjectId: nil, inmanagedObjectContext: managedObjectContext!)
        DiveInfo.diveInfoFromDictionary(dive2, imageDatum: [NSData](), updateObjectId: nil, inmanagedObjectContext: managedObjectContext!)
        DiveInfo.diveInfoFromDictionary(dive3, imageDatum: [NSData](), updateObjectId: nil, inmanagedObjectContext: managedObjectContext!)
        DiveInfo.diveInfoFromDictionary(dive4, imageDatum: [NSData](), updateObjectId: nil, inmanagedObjectContext: managedObjectContext!)
        DiveInfo.diveInfoFromDictionary(dive5, imageDatum: [NSData](), updateObjectId: nil, inmanagedObjectContext: managedObjectContext!)
        do {
            try managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //if the user flips the switch, switch all values to metric or vice versa
    @IBAction func switchMetric(sender: AnyObject) {
        if metricSwitch.on {
            defaults.setBool(true, forKey: "metric")
        } else {
            defaults.setBool(false, forKey: "metric")
        }
    }
    
    @IBOutlet weak var metricSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if settings saved from last time set switch equal to saved value
        if (defaults.objectForKey("metric") != nil) {
            metricSwitch.on = defaults.boolForKey("metric")
        } else {
            metricSwitch.on = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
