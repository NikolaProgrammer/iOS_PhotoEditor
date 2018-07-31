//
//  FilterService.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 30.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit
import CoreImage

class FilterService {
    
    //MARK: Properties
    let filterNames = ["Noir", "Sepia Tone", "Fade", "Transfer", "Gaussian Blur", "Hue Adjust"]
    
    private let filters: [FilterEffect] = [
        FilterEffect(name: "CIPhotoEffectNoir", displayName: "Noir", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CISepiaTone", displayName: "Sepia Tone", effectValue: 0.8, effectValueName: kCIInputIntensityKey),
        FilterEffect(name: "CIPhotoEffectFade", displayName: "Fade", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIPhotoEffectTransfer", displayName: "Transfer", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIGaussianBlur", displayName: "Gaussian Blur", effectValue: 8.0, effectValueName: kCIInputRadiusKey),
        FilterEffect(name: "CIHueAdjust", displayName: "Hue Adjust", effectValue: 2.0, effectValueName: kCIInputAngleKey)
    ]
    
    //MARK: Methods
    func processImage(_ image: UIImage, filterName: String, completion: @escaping (UIImage) -> ()) {
        
        let context = CIContext(eaglContext: EAGLContext(api: .openGLES3)!)
        let ciImage = CIImage(cgImage: image.cgImage!)
        
        guard let filterEffect = filters.first(where: { (filter) -> Bool in
            filter.displayName == filterName
        }) else {
            print("Incorrect filter name")
            return
        }
        let filter = CIFilter(name: filterEffect.name)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.effectValue, let filterEffectValueName = filterEffect.effectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let outCIImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage, let outputImage = context.createCGImage(outCIImage, from: outCIImage.extent) {
                let filteredImage = UIImage(cgImage: outputImage)
                DispatchQueue.main.async {
                    completion(filteredImage)
                }
            }
            
        }
    }
}
