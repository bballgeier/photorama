//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/13/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import Foundation
import CoreData

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
} // end enum Method

enum PhotosResult {
    case Success([Photo])
    case Failure(Error)
} // end enum PhotosResult

enum FlickrError: Error {
    case InvalidJSONData
} // end enum FlickrError

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return formatter
    }()
    
    private static func flickrURL(method: Method,
                                  parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)! // forgot ! originally
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
        "method": method.rawValue,
        "format": "json",
        "nojsoncallback": "1",
        "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        } // end for
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            } // end for
        } // end if let
//        components?.queryItems = queryItems
        components.queryItems = queryItems
        
//        return (components?.url)!
        return components.url!
        
    } // end flickrURL(method:parameters:)
    
    static func recentPhotosURL() -> URL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    } // end recentPhotosURL()
    
    static func photosFromJSONData(data: Data, inContext context: NSManagedObjectContext) -> PhotosResult {
        do {
            let jsonObject: Any =
                try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [String:AnyObject],
                let photos = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photos["photo"] as? [[String:AnyObject]]
                else {
                    // The JSON structure doesn't match our expectations
                    return .Failure(FlickrError.InvalidJSONData)
            } // end guard/else
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON, inContext: context) {
                    finalPhotos.append(photo)
                } // end if let
            } // end for
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                // We weren't able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .Failure(FlickrError.InvalidJSONData)
            }
            return .Success(finalPhotos)
        } // end do
        catch let error {
            return .Failure(error)
        } // end catch
    } // end photosFromJSONData(data:)
    
    private static func photoFromJSONObject(json: [String : AnyObject], inContext context: NSManagedObjectContext) -> Photo? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString)
            else {
                
                // Don't have enough information to construct a Photo
                return nil
        } // end guard/else
        
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        let predicate = NSPredicate(format: "photoID == \(photoID)")
        fetchRequest.predicate = predicate
        
        var fetchedPhotos: [Photo]!
        context.performAndWait {
            fetchedPhotos = try! context.fetch(fetchRequest)
        } // end closure for perforAndWait
        if fetchedPhotos.count > 0 {
            return fetchedPhotos.first
        } // end if
        
//        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
        var photo: Photo!
        context.performAndWait {
            photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url
            photo.dateTaken = dateTaken
        } // end closure for performAndWait()
        
        return photo
    } // end photoFromJSONObject(json:)
    
} // end struct FlickrAPI
