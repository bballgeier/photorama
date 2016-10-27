//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/12/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
                
        store.fetchRecentPhotos() { // set up completion handler
            (photosResult) -> Void in
            
//            switch photosResult {
//            case let .Success(photos):
//                print("Successfully found \(photos.count) recent photos.")
//                
//                if let firstPhoto = photos.first {
//                    self.store.fetchImageForPhoto(photo: firstPhoto) { // set up completion handler
//                        (imageResult) -> Void in
//                        
//                        switch imageResult {
//                        case let .Success(image):
////                            self.imageView.image = image
//                            OperationQueue.main.addOperation {
//                                self.imageView.image = image
//                            }
//                        case let .Failure(error):
//                            print("Error downloading image: \(error)")
//                        } // end switch
//                    } // end trailing closure for last parameter of fetchImageForPhoto(photo:completion:)
//                } // end if let
//            case let .Failure(error):
//                print("Error fetching recent photos: \(error)")
//            } // end switch photosResult
            
//            OperationQueue.main.addOperation() {
//                switch photosResult {
//                case let .Success(photos):
//                    print("Successfully found \(photos.count) recent photos")
//                    self.photoDataSource.photos = photos
//                case let .Failure(error):
//                    self.photoDataSource.photos.removeAll()
//                    print("Error fetching recent photos: \(error)")
//                } // end switch PhotosResult
//                self.collectionView.reloadSections(IndexSet(integer: 0) )
//            } // end OperationQueue.main.addOperation block
            
            let sortByTaken = NSSortDescriptor(key: "dateTaken", ascending: false)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByTaken])
            
            OperationQueue.main.addOperation {
                print("We have \(allPhotos.count) photos")
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(IndexSet(integer: 0))
            } // end addOperation closure
            
        } // end trailing closure for fetchRecentPhotos(completion:)
    } // end viewDidLoad()
    
    // UICollectionViewDelegate method
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            
            OperationQueue.main.addOperation {
                
                // The index path for the photo might have changed between the
                // time the request started and finished, so find the most
                // recent index path
                
                let photoIndex = self.photoDataSource.photos.index(of: photo)!
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
//                print("Passed in index: \(indexPath.row) -- recent index: \(photoIndex)")
//                print("difference in indexes: \(indexPath.row - photoIndex)")
                
                // When the request finishes, only update the cell if it's still visible
                if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                } // end if let
                
            } // end addOperation block
            
        } // end completion handler closure
    } // end collectionView(_:willDisplay:forItemAt:)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                // increment times viewed
                photo.timesViewed += 1
                do {
                    try store.coreDataStack.saveChanges()
                } // end do
                catch let error {
                    print("Error is \(error)")
                } // end catch
                print("view \(photo.timesViewed) times")
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            } // end if let
        } // end if
    } // end prepare(for:sender:)
    
    // implement UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = CGFloat(self.view.frame.width / 4.0 - 2.5)
        let cellSize = CGSize(width: width, height: (9/5) * width)
        return cellSize
    } // end collectionView(_:layout:sizeForItemAt:)
    
    // to rest when rotating phone
    // override UIViewController method
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("called viewWillTransition(to:with:)")
        
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
} // end class PhotosViewController
