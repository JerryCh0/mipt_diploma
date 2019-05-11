//
//  UIImage+Utils.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 10/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import CoreML

func transpose(_ matrix: [[NSNumber]]) -> [[NSNumber]] {
    let rowCount = matrix.count
    let colCount = matrix[0].count
    var transposed : [[NSNumber]] = Array(repeating: Array(repeating: 0.0, count: rowCount), count: colCount)
    for rowPos in 0..<matrix.count {
        for colPos in 0..<matrix[0].count {
            transposed[colPos][rowPos] = matrix[rowPos][colPos]
        }
    }
    return transposed
}

extension UIImage {
    
    func preparedInput() -> MLMultiArray? {
        let matrix = OpenCVWrapper.prepare(
            forML: self.resize(targetSize: CGSize(width: 512, height: 64))
        )
        return mlMultiArray(matrix: transpose(matrix))
    }
    
    private func floatMatrix(_ matrix: [[NSNumber]]) -> [[Float]] {
        let height = matrix.count
        let width = matrix.first?.count ?? 0
        
        let tmp = [Float].init(repeating: 0, count: width)
        var result = [[Float]].init(repeating: tmp, count: height)
        
        for yCo in 0..<height {
            for xCo in 0..<width {
                result[yCo][xCo] = matrix[yCo][xCo].floatValue
            }
        }
        
        return result
    }
    
    private func mlMultiArray(matrix: [[NSNumber]]) -> MLMultiArray? {
        do {
            let xMax = matrix.first?.count ?? 0
            let yMax = matrix.count
            
            let result = try MLMultiArray(
                shape: [NSNumber(value: 512 * 64)],
                dataType: .double
            )
            
            for yCo in 0..<yMax {
                for xCo in 0..<xMax {
                    let val = matrix[yCo][xCo].floatValue
                    result[yCo * xMax + xCo] = NSNumber(value: val)
                }
            }
            
            return result
        } catch {
            return nil
        }
    }
    
//    func getPixelChannel(x: Int, y: Int) -> NSNumber {
//
//        let pixelData = self.cgImage?.dataProvider?.data!
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//
//        let pixelInfo: Int = ((Int(self.size.width) * y + x)) * 4
//
//        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
//
//        return NSNumber(value: Double(0.299 * r + 0.587 * g + 0.114 * b))
//    }

    func resize(targetSize: CGSize) -> UIImage {
        
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
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

//func preprocess(image: UIImage) -> MLMultiArray? {
//
//    do {
//        let result = try MLMultiArray(shape: [1, 512, 64], dataType: .double)
//        let yMax = Int(image.size.height)
//        let xMax = Int(image.size.width)
//        let grayScaleImage = image.g8_grayScale()!
//
//        for yCo in 0 ..< yMax {
//            for xCo in 0 ..< xMax {
//                result[yCo * 512 + xCo] = grayScaleImage.getPixelChannel(x: xCo, y: yCo)
//            }
//        }
//
//        return result
//    } catch {
//        return nil
//    }
//}
