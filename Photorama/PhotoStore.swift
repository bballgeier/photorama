//
//  PhotoStore.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/13/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit
import CoreData

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
} // end enum ImageResult

enum PhotoError: Error {
    case ImageCreationError
} // end PhotoError

class PhotoStore {
    
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    let imageStore = ImageStore()
        
    let session: URLSession = {
       let config = URLSessionConfiguration.default
       return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {    // trailing closure as last argument
            (data, response, error) -> Void in
            
//            print("type of error is \(type(of: error))")  // error is Optional<Error>
                                                            // consistent with compiler error
                                                            // but documentation says NSError -- so?
            
//            if let jsonData = data {
////                if let jsonString = String(data: jsonData,
////                                           encoding: String.Encoding.utf8) {
////                    print(jsonString)
////                } // end if let
//                do {
//                    let jsonObject: Any
//                        = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                    print(jsonObject)
//                } // end do
//                catch let error {
//                    print("Error creating JSON object: \(error)")
//                } // end catch let
//            
//            } // end if let
//            else if let requestError = error {
//                print("Error fetching recent photos: \(requestError)")
//            } // end else if
//            else {
//                print("Unexpected error with request")
//            } // end else
            
//            print("Response: \(response)\n")
            
//            if let responseInfo = response as? HTTPURLResponse {
//                print("fetchRecentPhotos: statusCode: \(responseInfo.statusCode)")
//                print("fetchRecentPhotos: headerFields:")
//                for (key, value) in responseInfo.allHeaderFields {
//                    print("\(key): \(value)")
//                }
//                print("")
//            }
            
//            print("fetchRecentPhotos: statusCode: \((response as? HTTPURLResponse)?.statusCode)")
//            print("fetchRecentPhotos: headerFields: \((response as? HTTPURLResponse)?.allHeaderFields)")
            
//            let result = self.processRecentPhotosRequest(data: data, error: error as? NSError)
            var result = self.processRecentPhotosRequest(data: data, error: error as NSError?)
            
            if case let .Success(photos) = result {
                let mainQueueContext = self.coreDataStack.mainQueueContext
                mainQueueContext.performAndWait {
                    try! mainQueueContext.obtainPermanentIDs(for: photos)
                } // end closure for performAndWait
                let objectIDs = photos.map { $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: false)
                
                do {
                    try self.coreDataStack.saveChanges()
                    
                    let mainQueuePhotos = try self.fetchMainQueuePhotos(predicate: predicate, sortDescriptors: [sortByDateTaken])
                    result = .Success(mainQueuePhotos)
                } // end do
                catch let error {
                    result = .Failure(error)
                } // end catch let
            } // end if case
            
            completion(result)
        } // end closure
        
        task.resume()
    } // end fetchRecentPhotos()
    
    func processRecentPhotosRequest(data: Data?, error: NSError?) -> PhotosResult {
        guard let jsonData = data
            else {
                return .Failure(error!)
        } // end guard/else
        
        return FlickrAPI.photosFromJSONData(data: jsonData, inContext: self.coreDataStack.mainQueueContext)
    } // end processRecentPhotosRequest(data:error:)
    
    func fetchImageForPhoto(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        let photoKey = photo.photoKey
//        if let image = photo.image {
        if let image = imageStore.imageForKey(photoKey) {
            photo.image = image
            completion(.Success(image))
            return
        } // end if let
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
//            print("fetchImageForPhoto: statusCode: \((response as? HTTPURLResponse)?.statusCode)")
//            print("fetchImageForPhoto: headerFields: \((response as? HTTPURLResponse)?.allHeaderFields)")

            
            let result = self.processImageRequest(data: data, error: error as NSError?)
            
            if case let .Success(image) = result {
                photo.image = image
                self.imageStore.setImage(image, forKey: photoKey)
            } // end if case
            
            completion(result)
            
        } // end trailing closure for last parameter dataTask(with:)
        task.resume()
    } // end fetchImageForPhoto(photo:completion:)
    
    func processImageRequest(data: Data?, error: NSError?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
            else {
                
                // Couldn't create an image
                if data == nil {
                    return .Failure(error!)
                } // end if
                else {
                    return .Failure(PhotoError.ImageCreationError)
                } // end else
        } // end guard/else
        
        return .Success(image)
    } // end processImageRequest(data:error:)
    
    func fetchMainQueuePhotos(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Photo] {
        
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePhotos: [Photo]?
        var fetchRequestError: Error?
        mainQueueContext.performAndWait {
            do {
                // book used execute -- but Swift3 added fetch -- not sure what execute does
                mainQueuePhotos = try mainQueueContext.fetch(fetchRequest)
            } // end do
            catch let error {
                fetchRequestError = error
            } // end catch
        } // end closure for performAndWait
        
        guard let photos = mainQueuePhotos
            else {
            throw fetchRequestError!
        } // end guard/else
        
        return photos
        
    } // end fetchMainQueuePhotos(predicate:sortDescriptors:)
    
} // end class PhotoStore
