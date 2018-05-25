//
//  DiveInfo+CoreDataProperties.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/5/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DiveInfo {

    @NSManaged var air_temp: NSNumber?
    @NSManaged var air_type: String?
    @NSManaged var buddy: String?
    @NSManaged var date: NSDate?
    @NSManaged var dive_site: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var end_psi: NSNumber?
    @NSManaged var end_time: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var max_depth: NSNumber?
    @NSManaged var notes: String?
    @NSManaged var start_psi: NSNumber?
    @NSManaged var start_time: NSDate?
    @NSManaged var tank_type: String?
    @NSManaged var tank_volume: NSNumber?
    @NSManaged var visibility: NSNumber?
    @NSManaged var water_temp: NSNumber?
    @NSManaged var weather: String?
    @NSManaged var location: String?
    @NSManaged var images: NSOrderedSet?

}
