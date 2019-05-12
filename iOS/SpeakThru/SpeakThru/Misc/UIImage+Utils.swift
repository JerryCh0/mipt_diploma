//
//  UIImage+Utils.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 10/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import CoreML

private func transpose(_ matrix: [[NSNumber]]) -> [[NSNumber]] {
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

    func resize(targetSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
