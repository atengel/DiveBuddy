//
//  DiveInfo.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/17/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import Foundation
import CoreData


class DiveInfo: NSManagedObject {
    
    //either create a new DiveInfo object or update an existing one.
    class func diveInfoFromDictionary(diveInfo: Dictionary<String, String?> , imageDatum: [NSData], updateObjectId: NSManagedObjectID?, inmanagedObjectContext context: NSManagedObjectContext){
        //if we have an existing object
        if updateObjectId != nil {
            //fetch it
            let request = NSFetchRequest(entityName: "DiveInfo")
            let predicate = NSPredicate(format: "self = %@", updateObjectId!)
            request.predicate = predicate
            do {
                let queryResult = try context.executeFetchRequest(request)
                if let updatedDiveInfo = queryResult.first as? DiveInfo {
                    //use the updated info to set each value in the updated DiveInfo to its new value
                    
                    //formatter for dates
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    if diveInfo["date"] != nil {
                        updatedDiveInfo.setValue(dateFormatter.dateFromString(diveInfo["date"]!!)!, forKey: "date")
                    }
                    if diveInfo["buddy"] != nil {
                        updatedDiveInfo.setValue(diveInfo["buddy"]!, forKey: "buddy")
                    }
                    
                    if diveInfo["latitude"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["latitude"]!!)!, forKey: "latitude")
                    }
                    if diveInfo["longitude"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["longitude"]!!)!, forKey: "longitude")
                    }
                    if diveInfo["dive_site"] != nil {
                        updatedDiveInfo.setValue(diveInfo["dive_site"]!, forKey: "dive_site")
                    }
                    if diveInfo["weather"] != nil {
                        updatedDiveInfo.setValue(diveInfo["weather"]!, forKey: "weather")
                    }
                    if diveInfo["air_temp"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["air_temp"]!!)!, forKey: "air_temp")
                    }
                    if diveInfo["water_temp"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["water_temp"]!!)!, forKey: "water_temp")
                    }
                    if diveInfo["visibility"] != nil {
                        updatedDiveInfo.setValue(Int(diveInfo["visibility"]!!)!, forKey: "visibility")
                    }
                    //formatter for times
                    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                    dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                    dateFormatter.dateFormat = "hh:mm a"
                    
                    if(diveInfo["start_time"] != nil) && diveInfo["start_time"]!! != "" {
                        updatedDiveInfo.setValue(dateFormatter.dateFromString(diveInfo["start_time"]!!)!, forKey: "start_time")
                    }
                    if(diveInfo["end_time"] != nil) {
                        updatedDiveInfo.setValue(dateFormatter.dateFromString(diveInfo["end_time"]!!)!, forKey: "end_time")
                    }
                    //calculate the dive duration
                    if updatedDiveInfo.start_time != nil && updatedDiveInfo.end_time != nil {
                        let cal = NSCalendar.currentCalendar()
                        let unit:NSCalendarUnit = .Minute
                        let components = cal.components(unit, fromDate: updatedDiveInfo.start_time!, toDate: updatedDiveInfo.end_time!, options: [])
                        updatedDiveInfo.duration = components.minute
                    }
                    if diveInfo["max_depth"] != nil {
                        updatedDiveInfo.setValue(Int(diveInfo["max_depth"]!!)!, forKey: "max_depth")
                    }
                    if diveInfo["tank_type"] != nil {
                        updatedDiveInfo.setValue(diveInfo["tank_type"]!, forKey: "tank_type")
                    }
                    if diveInfo["tank_vol"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["tank_vol"]!!)!, forKey: "tank_vol")
                    }
                    if diveInfo["air_type"] != nil {
                        updatedDiveInfo.setValue(diveInfo["air_type"]!, forKey: "air_type")
                    }
                    if diveInfo["start_psi"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["start_psi"]!!)!, forKey: "start_psi")
                    }
                    if diveInfo["end_psi"] != nil {
                        updatedDiveInfo.setValue(Double(diveInfo["end_psi"]!!)!, forKey: "end_psi")
                    }
                    if diveInfo["notes"] != nil {
                        updatedDiveInfo.setValue(diveInfo["notes"]!, forKey: "notes")
                    }
                    if diveInfo["location"] != nil {
                        updatedDiveInfo.setValue(diveInfo["location"]!, forKey: "location")
                    }
                    //add all new images to the DiveInfo
                    if imageDatum.count > 0 {
                        for imageData in imageDatum {
                            Image.imageFromNSData(imageData, newDive: updatedDiveInfo,inmanagedObjectContext: context)
                        }
                    }
                    
                }
                
            } catch _ {
                //ignore
            }
        }else {
            //if we are creating a new DiveInfo, insert it and set its attributes
            if let newDive = NSEntityDescription.insertNewObjectForEntityForName("DiveInfo", inManagedObjectContext: context) as? DiveInfo {
                //formatter for date
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateFormat = "MM/dd/yyyy"
                
                if diveInfo["date"] != nil {
                    newDive.date = dateFormatter.dateFromString(diveInfo["date"]!!)!
                }
                if diveInfo["buddy"] != nil {
                    newDive.buddy = diveInfo["buddy"]!
                }
                
                if diveInfo["latitude"] != nil {
                    newDive.latitude? = Double(diveInfo["latitude"]!!)!
                }
                if diveInfo["longitude"] != nil {
                    newDive.longitude? = Double(diveInfo["longitude"]!!)!
                }
                if diveInfo["dive_site"] != nil {
                    newDive.dive_site = diveInfo["dive_site"]!
                }
                if diveInfo["weather"] != nil {
                    newDive.weather = diveInfo["weather"]!
                }
                if diveInfo["air_temp"] != nil {
                    newDive.air_temp? = Double(diveInfo["air_temp"]!!)!
                }
                if diveInfo["water_temp"] != nil {
                    newDive.water_temp? = Double(diveInfo["water_temp"]!!)!
                }
                if diveInfo["visibility"] != nil {
                    newDive.visibility = Int(diveInfo["visibility"]!!)!
                }
                //formatter for time
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.dateFormat = "hh:mm a"
                
                if(diveInfo["start_time"] != nil) && diveInfo["start_time"]!! != "" {
                    newDive.start_time = dateFormatter.dateFromString(diveInfo["start_time"]!!)!
                }
                if(diveInfo["end_time"] != nil) {
                    newDive.end_time = dateFormatter.dateFromString(diveInfo["end_time"]!!)!
                }
                //calculate duration of dive using NSCalendarComponents
                if newDive.start_time != nil && newDive.end_time != nil {
                    let cal = NSCalendar.currentCalendar()
                    let unit:NSCalendarUnit = .Minute
                    let components = cal.components(unit, fromDate: newDive.start_time!, toDate: newDive.end_time!, options: [])
                    newDive.duration = components.minute
                }
                if diveInfo["max_depth"] != nil {
                    newDive.max_depth = Int(diveInfo["max_depth"]!!)!
                }
                if diveInfo["tank_type"] != nil {
                    newDive.tank_type = diveInfo["tank_type"]!
                }
                if diveInfo["tank_vol"] != nil {
                    newDive.tank_volume = Double(diveInfo["tank_vol"]!!)!
                }
                if diveInfo["air_type"] != nil {
                    newDive.air_type = diveInfo["air_type"]!
                }
                if diveInfo["start_psi"] != nil {
                    newDive.start_psi = Int(diveInfo["start_psi"]!!)!
                }
                if diveInfo["end_psi"] != nil {
                    newDive.end_psi = Int(diveInfo["end_psi"]!!)!
                }
                if diveInfo["notes"] != nil {
                    newDive.notes = diveInfo["notes"]!
                }
                if diveInfo["location"] != nil {
                    newDive.location = diveInfo["location"]!
                }
                //add all images as NSData
                if imageDatum.count > 0 {
                    for imageData in imageDatum {
                        
                        Image.imageFromNSData(imageData, newDive: newDive,inmanagedObjectContext: context)
                    }
                }
            }
        }
        
    }
    
}
