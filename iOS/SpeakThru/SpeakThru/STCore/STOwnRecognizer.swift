//
//  STOwnRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import CoreML
import Vision

final class STOwnRecognizer: Recognizer {
    
    func recognize(from image: UIImage) {
        vision.makeRequest(image: image)
    }
    
    private func predictionToString(_ pred: MLMultiArray) -> String {
        var result = String()
        let stripe = 128
        for k in 2..<stripe {
            var currentMax = Double(0)
            var index = 0
            for i in (k * ALPHABET.count)..<(k*ALPHABET.count + ALPHABET.count) {
                if pred[i].doubleValue > currentMax {
                    index = i
                    currentMax = pred[i].doubleValue
                }
            }
            if currentMax > 0.1 {
                result += ALPHABET[index % ALPHABET.count]
            }
        }
        return result
    }
    
    private func parseResults(image: UIImage, results: [UIImage]) {
        var stringResult = String()
        
        let options = MLPredictionOptions()
        options.usesCPUOnly = true
        
        for result in results {
            guard let input1 = result.preparedInput() else { continue }
            let input = keras_ocrInput(input1: input1)
            do {
                let prediction = try model.prediction(input: input, options: options)
                stringResult += "\n\(predictionToString(prediction.output1))"
            } catch {
                print(error.localizedDescription)
                continue
            }
        }
        
        coreRecognizer?.onRecognized(from: image, text: stringResult, lang: "en")
    }
    
    private let model = keras_ocr()
    private lazy var vision: STVision = {
        let vis = STVision()
        vis.delegate = self
        return vis
    }()
    private lazy var box: BoxService = {
        let bx = BoxService()
        bx.delegate = self
        return bx
    }()
    
    private let ALPHABET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", ""]
    
    weak var coreRecognizer: STRecognizer?
}

extension STOwnRecognizer: STVisionDelegate {
    func service(_ version: STVision, didDetect image: UIImage, results: [VNTextObservation]) {
        box.handle(image: image, results: results)
    }
}

extension STOwnRecognizer: BoxServiceDelegate {
    func boxService(_ service: BoxService, didDetect images: [UIImage], on image: UIImage) {
        return
    }
}
