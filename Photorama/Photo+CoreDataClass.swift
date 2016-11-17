//
//  Photo+CoreDataClass.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/20/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit
import CoreData


public class Photo: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    var image: UIImage?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
//        print(#function)
        
        // since calling the save() function, only get an error if don't 
        // have photoKey initialized. The others are getting initialized 
        // in FlickrAPI's photoFromJSONObject via context's perform and wait
                
        // Give the properties their initial values
//        title = ""
//        photoID = ""
//        remoteURL = URL(fileURLWithPath: "") // can't give no argument
        photoKey = UUID().uuidString
        timesViewed = 0
//        dateTaken = Date()
    } // end awakeFromInsert()
    
    func addTagObject(_ tag: NSManagedObject) {
        let currentTags = self.mutableSetValue(forKey: "tags")
        currentTags.add(tag)
    } // end addTagObject(_:)
    
    func removeTagObject(_ tag: NSManagedObject) {
        let currentTags = mutableSetValue(forKey: "tags")
        currentTags.remove(tag)
    } // end removeTagObject(_:)

} // end class Photo
