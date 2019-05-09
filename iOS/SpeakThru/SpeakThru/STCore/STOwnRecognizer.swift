//
//  STOwnRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import CoreML

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize = targetSize
//    if(widthRatio > heightRatio) {
//        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//    } else {
//        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

extension UIImage {
    
    func getPixelChannel(pos: CGPoint) -> NSNumber {
        
        let pixelData = self.cgImage?.dataProvider?.data!
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        
        return NSNumber(value: Double(0.299 * r + 0.587 * g + 0.114 * b))
    }
}

func preprocess(image: UIImage) -> MLMultiArray? {
    
    do {
        let result = try MLMultiArray(shape: [1, 128, 64], dataType: .double)
        
        for yCo in 0 ..< Int(image.size.height) {
            for xCo in 0 ..< Int(image.size.width) {
                result[yCo * 128 + xCo] = image.g8_grayScale()!.getPixelChannel(pos: CGPoint(x: xCo, y: yCo))
            }
        }
        
        return result
    } catch {
        return nil
    }
}

final class STOwnRecognizer: Recognizer {
    
    func recognize(from image: UIImage) {
        
        do {
            let array = try MLMultiArray(shape: [1, 128, 64], dataType: .double)
            let model = apnr_ocr()
            let input = apnr_ocrInput(input1: array)
            let prediction = try model.prediction(input: input)
            print(prediction.output1)
        } catch {
            return
        }
    }
    
    
    
    
}
