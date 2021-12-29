//
//  FilterService.swift
//  CameraFilter
//
//  Created by Nicholas Forte on 28/12/21.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context:CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { observer in
            
            self.applyFilter(to: inputImage) { filteredeImage in
                observer.onNext(filteredeImage)
            }
            
            return Disposables.create()
            
        }
    }
    
    private func applyFilter(to inputImage: UIImage, complition: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgImg = self.context.createCGImage(filter.outputImage!, from:
                                                        filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgImg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                
                complition(processedImage)
            }
        }
    }
    
}
