//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Benjamin Allgeier on 10/18/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateWithImage(_ image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } // end if let
        else {
            spinner.startAnimating()
            imageView.image = nil
        }
    } // end updateWithImage(_:)
    
    // an NSObject instance method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
    } // end awakeFromNib()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    } // end prepareForReuse()
    
} // end class PhotoCollectionViewCell
