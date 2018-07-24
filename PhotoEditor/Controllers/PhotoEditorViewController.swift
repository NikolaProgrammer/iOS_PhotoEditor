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
    var imageForEditing: UIImage!
    
    let filters: [FilterEffect] = [
        FilterEffect(name: "CIPhotoEffectNoir", displayName: "Noir", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CISepiaTone", displayName: "Sepia Tone", effectValue: 0.8, effectValueName: kCIInputIntensityKey),
        FilterEffect(name: "CIPhotoEffectFade", displayName: "Fade", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIPhotoEffectTransfer", displayName: "Transfer", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIGaussianBlur", displayName: "Gaussian Blur", effectValue: 8.0, effectValueName: kCIInputRadiusKey),
        FilterEffect(name: "CIHueAdjust", displayName: "Hue Adjust", effectValue: 2.0, effectValueName: kCIInputAngleKey)
    ]
    
    var filteredImages: [UIImage?]!
    
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredImages = Array(repeating: nil, count: filters.count)
        editingImageView.image = imageForEditing
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    //MARK: Private Methods
    @objc private func saveButtonTapped() {
        UIImageWriteToSavedPhotosAlbum(editingImageView.image!, nil, nil, nil)
    }
    
    private func processImageForCell(_ cell: ImageFilterCollectionViewCell , image: UIImage, withFilter filterEffect: FilterEffect) {
        let context = CIContext(eaglContext: EAGLContext(api: .openGLES3)!)

        let ciImage = CIImage(cgImage: image.cgImage!)
        let filter = CIFilter(name: filterEffect.name)

        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        if let filterEffectValue = filterEffect.effectValue, let filterEffectValueName = filterEffect.effectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        cell.processingIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            if let outCIImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage, let outputImage = context.createCGImage(outCIImage, from: outCIImage.extent) {
                let filteredImage = UIImage(cgImage: outputImage)
                
                let index = self.filters.index(of: filterEffect)!
                self.filteredImages[index] = filteredImage
                
                DispatchQueue.main.async {
                    cell.previewImageView.image = filteredImage
                    cell.processingIndicator.stopAnimating()
                }
            }
        }
        
    }
}

extension PhotoEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageFilter", for: indexPath) as! ImageFilterCollectionViewCell
        let filter = filters[indexPath.item]
        
        if let filteredImage = filteredImages[indexPath.item] {
            cell.previewImageView.image = filteredImage
        } else {
            processImageForCell(cell, image: imageForEditing, withFilter: filter)
        }
        
        cell.effectName.text = filter.displayName
        
        return cell
    }
}

extension PhotoEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editingImageView.image = filteredImages[indexPath.item]
    }
}
