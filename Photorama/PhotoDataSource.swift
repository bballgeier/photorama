//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/18/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    } // end collectionView(_:numberOfItemsInSection:)
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.updateWithImage(photo.image)
        
        return cell
    } // end collectionView(_:cellForItemAt:)
    
} // end class PhotoDataSource
