//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit
import CoreImage

class PhotoEditorViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editingImageView: UIImageView!
    
    var filteredImages: [UIImage?]!
    var imageForEditing: UIImage!
    let filterService = FilterService()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredImages = Array(repeating: nil, count: filterService.filterNames.count)
        
        editingImageView.image = imageForEditing
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    //MARK: Private Methods
    @objc private func saveButtonTapped() {
        UIImageWriteToSavedPhotosAlbum(editingImageView.image!, nil, nil, nil)
    }
    
}

extension PhotoEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterService.filterNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageFilter", for: indexPath) as! ImageFilterCollectionViewCell
        let filterName = filterService.filterNames[indexPath.row]
        
        cell.effectName.text = filterName
        
        if let filteredImage = filteredImages[indexPath.item] {
            cell.previewImageView.image = filteredImage
        } else {
            cell.processingIndicator.startAnimating()
            filterService.processImage(imageForEditing, filterName: filterName) { (image) in
                cell.previewImageView.image = image
                self.filteredImages[indexPath.item] = image
                cell.processingIndicator.stopAnimating()
            }
        }
 
        return cell
    }
}

extension PhotoEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageFilterCollectionViewCell
        editingImageView.image = cell.previewImageView.image
    }
}
