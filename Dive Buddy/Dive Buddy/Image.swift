//
//  Image.swift
//  Dive Buddy
//
//  Created by Alexander Engel on 5/17/16.
//  Copyright © 2016 Alex Engel. All rights reserved.
//

import Foundation
import CoreData


class Image: NSManagedObject {

    class func imageFromNSData(imageData: NSData, newDive: DiveInfo,inmanagedObjectContext context: NSManagedObjectContext){
        if let newImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: context) as? Image {
            newImage.image_data = imageData;
            newImage.dive = newDive
            print(newImage)
        }
        
    }

}
