//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/19/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var timesViewLabel: UILabel!
    @IBOutlet var dateTakenLabel: UILabel!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        } // end didSet
    } // end photo with property observer
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the line below seems to work (and without using store)
        // perhaps the code below this is safer somehow
        self.imageView.image = photo.image
        
        self.timesViewLabel.text = "Viewed \(photo.timesViewed) times"
        self.dateTakenLabel.text = "Taken \(photo.dateTaken)"
        
//        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
//            
//            switch result {
//            case let .Success(image):
//                OperationQueue.main.addOperation {
//                    self.imageView.image = image
//                } // end addOperation block
//            case let .Failure(error):
//                print("Error fetching image for photo: \(error)")
//            } // end switch result
//        } // end completion handler for fetchImageForPhoto(photo:completion:)
    } // end viewDidLoad()
    
} // end class PhotoInfoViewController
