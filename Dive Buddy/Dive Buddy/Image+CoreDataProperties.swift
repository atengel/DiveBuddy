//
//  Image+CoreDataProperties.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 6/1/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var image_data: NSData?
    @NSManaged var dive: DiveInfo?

}
