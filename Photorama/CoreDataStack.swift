//
//  CoreDataStack.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/20/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import Foundation
import  CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }() // end closure call for defining managedObjectModel
    
    private var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }() // end closure call for defining applicationDocumentsDirectory
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        
        return coordinator
    }() // end closure call for defining persistentStoreCoordinator
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
    }() // end closure for defining mainQueueContext
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    } // end init(modelName:)
    
    func saveChanges() throws {
        var error: Error?
        mainQueueContext.performAndWait {
            
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                } // end do
                catch let saveError {
                    error = saveError
                } // end catch
            } // end if
        } // end closure for perforAndWait
        if let error = error {
            throw error
        } // end if
    } // end saveChanges()
    
} // end class CoreDataStack
