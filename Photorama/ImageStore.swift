//
//  ImageStore.swift
//  Homepwner and now Photrama
//
//  Created by Benjamin Allgeier on 10/3/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        let imageURL = imageURLForKey(key)
        
        // Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
//        if let data = UIImagePNGRepresentation(image) {
            // Write it to full URL
            do {
            try data.write(to: imageURL, options: .atomic)
            } // end do
            catch {
                
            }
        } // end if let
    
    } // end setImage(_:forKey:)
    
    func imageForKey(_ key: String) -> UIImage? {
//        return cache.object(forKey: key as NSString)
        
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        } // end if let
        
        let imageURL = imageURLForKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
        
    } // end imageForKey(_:)
    
    func deleteImageForKey(_ key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let imageURL = imageURLForKey(key)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } // end do
//        catch {
//            print("Error removing the image from disk: \(error)")
//        } // end catch
        catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    } // end deleteImageForKey(_:)
    
    func imageURLForKey(_ key: String) -> URL {
        
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
        
    } // end imageURLForKey(_:)
    
} // end class ImageStore
