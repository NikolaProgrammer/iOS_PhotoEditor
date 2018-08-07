//
//  FilterService.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 30.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit
import CoreImage

enum FilterName: String {
    case noir = "CIPhotoEffectNoir"
    case sepia = "CISepiaTone"
    case fade = "CIPhotoEffectFade"
    case transfer = "CIPhotoEffectTransfer"
    case blur = "CIGaussianBlur"
    case hueAdjust = "CIHueAdjust"
    
    static let allCases: [FilterName] = [.noir, .sepia, .fade, .transfer, .blur, .hueAdjust]
}

class FilterService {
    
    //MARK: Properties
    private let filters: [FilterEffect] = [
        FilterEffect(name: "CIPhotoEffectNoir", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CISepiaTone", effectValue: 0.8, effectValueName: kCIInputIntensityKey),
        FilterEffect(name: "CIPhotoEffectFade", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIPhotoEffectTransfer", effectValue: nil, effectValueName: nil),
        FilterEffect(name: "CIGaussianBlur", effectValue: 8.0, effectValueName: kCIInputRadiusKey),
        FilterEffect(name: "CIHueAdjust", effectValue: 2.0, effectValueName: kCIInputAngleKey)
    ]
    
    //MARK: Methods
    func processImage(_ image: UIImage, filterName: FilterName, completion: @escaping (UIImage) -> ()) {
         DispatchQueue.global(qos: .userInitiated).async {
            
            let context = CIContext(options: nil)
            let ciImage = CIImage(image: image)
            
            guard let filterEffect = self.filters.first(where: { (filter) -> Bool in
                filter.name == filterName.rawValue
            }) else {
                print("Incorrect filter name")
                return
            }
            let filter = CIFilter(name: filterEffect.name)
            
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            if let filterEffectValue = filterEffect.effectValue, let filterEffectValueName = filterEffect.effectValueName {
                filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
            }

            if let outCIImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage, let outputImage = context.createCGImage(outCIImage, from: outCIImage.extent) {
                let filteredImage = UIImage(cgImage: outputImage)
                DispatchQueue.main.async {
                    completion(filteredImage)
                }
            }
            
        }
    }
}
