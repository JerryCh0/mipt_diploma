//
//  STTesseractRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 06/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Vision
import TesseractOCR
import AVFoundation
import UIKit

final class STTesseractRecognizer: Recognizer {
    
    func recognize(from image: UIImage) {
        vision.makeRequest(image: image)
    }
    
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
    private lazy var tesseract = G8Tesseract(language: "eng")!
    
    weak var coreRecognizer: STRecognizer?
}

extension STTesseractRecognizer: STVisionDelegate {
    func service(_ version: STVision, didDetect image: UIImage, results: [VNTextObservation]) {
        box.handle(image: image, results: results)
    }
}

extension STTesseractRecognizer: BoxServiceDelegate {
    func boxService(_ service: BoxService, didDetect images: [UIImage], on image: UIImage) {
        parse(photo: image, images: images)
    }
    
    private func parse(photo: UIImage, images: [UIImage]) {
        let tesseract = G8Tesseract(language: "eng")!
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleLine
        
        var result = ""
        
        for image in images {
            tesseract.image = image.g8_blackAndWhite()
            if tesseract.recognize() {
                result += " " + tesseract.recognizedText
            }
        }
        
        coreRecognizer?.onRecognized(from: photo, text: result, lang: "en")
    }
}
