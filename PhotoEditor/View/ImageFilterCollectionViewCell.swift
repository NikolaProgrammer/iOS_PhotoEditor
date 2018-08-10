//
//  ImageFilterCollectionViewCell.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ImageFilterCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var processingIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        previewImageView.image = nil
    }
}
