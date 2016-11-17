//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/27/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    // came from template -- note that it is public
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
//        return NSFetchRequest<Photo>(entityName: "Photo");
//    }
    
    // note template came with public variables

    @NSManaged public var dateTaken: Date
    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var remoteURL: URL
    @NSManaged public var title: String
    @NSManaged public var timesViewed: Int64
    @NSManaged public var tags: Set<NSManagedObject>

} // end extension Photo
