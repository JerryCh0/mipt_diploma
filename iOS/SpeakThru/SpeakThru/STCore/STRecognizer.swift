//
//  STRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import Firebase
import Vision
import TesseractOCR

protocol STRecognizerDelegate: class {
    func onRecognized(from photo: UIImage, text: String, lang: String)
}

private protocol Recognizer: class {
    func recognize(from image: UIImage)
}

final class STRecognizer: Recognizer, STRecognizerDelegate {
    
    func recognize(from image: UIImage) {
        vision.delegate = self
        box.delegate = self
        switch type {
        case .firebase:
            firebaseRecognizer.recognize(from: image)
        case .vision:
            vision.makeRequest(image: image)
            //visionRecognizer.recognize(from: image)
        }
    }
    
    func onRecognized(from photo: UIImage, text: String, lang: String) {
        delegate?.onRecognized(from: photo, text: text, lang: lang)
    }
    
    init() {
        type = RecognizerType.firebase
    }
    
    weak var delegate: STRecognizerDelegate?
    
    var type: RecognizerType
    
    private lazy var firebaseRecognizer: STFirebaseRecognizer = {
        let rec = STFirebaseRecognizer()
        rec.coreRecognizer = self
        return rec
    }()
    private lazy var visionRecognizer: STFirebaseRecognizer = {
        let rec = STFirebaseRecognizer()
        rec.coreRecognizer = self
        return rec
    }()
    private lazy var vision = STVision()
    private lazy var box = BoxService()
    private lazy var tesseract = G8Tesseract(language: "eng")!
}

extension STRecognizer: STVisionDelegate {
    func service(_ version: STVision, didDetect image: UIImage, results: [VNTextObservation]) {
        box.handle(image: image, results: results)
    }
}

extension STRecognizer: BoxServiceDelegate {
    
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
        
        delegate?.onRecognized(from: photo, text: result, lang: "en")
    }
}

// MARK: -FirebaseRecognizer

private final class STFirebaseRecognizer {
    
    func recognize(from image: UIImage) {
        let vImage = VisionImage(image: image)
        cloudTextRecognizer.process(vImage) { text, error in
            guard error == nil, let result = text else { return }
            self.coreRecognizer?.onRecognized(
                from: image,
                text: result.text,
                lang: result.blocks.first?.recognizedLanguages.first?.languageCode ?? ""
            )
        }
    }
    
    private let vision = Vision.vision()
    
    private lazy var deviceTextRecognizer = vision.onDeviceTextRecognizer()
    private lazy var cloudTextRecognizer = vision.cloudTextRecognizer()
    
    weak var coreRecognizer: STRecognizer?
}

// MARK: -RecognizerType

enum RecognizerType {
    case firebase
    case vision
}

private let TypeToString = [
    RecognizerType.firebase : "Firebase",
    RecognizerType.vision : "Vision+Tesseract"
]

func allRecognizers() -> [RecognizerType] {
    return Array(TypeToString.keys)
}

func string(from type: RecognizerType) -> String {
    return TypeToString[type] ?? ""
}

func type(from string: String) -> RecognizerType {
    for (key, value) in TypeToString {
        if value == string {
            return key
        }
    }
    return .firebase
}
