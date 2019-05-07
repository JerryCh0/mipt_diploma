//
//  STRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import Firebase

protocol STRecognizerDelegate: class {
    func onRecognized(from photo: UIImage, text: String, lang: String)
}

protocol Recognizer: class {
    func recognize(from image: UIImage)
}

final class STRecognizer: Recognizer, STRecognizerDelegate {
    
    func recognize(from image: UIImage) {
        switch type {
        case .firebase:
            firebaseRecognizer.recognize(from: image)
        case .vision:
            tesseractRecognizer.recognize(from: image)
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
    private lazy var tesseractRecognizer: STTesseractRecognizer = {
        let rec = STTesseractRecognizer()
        rec.coreRecognizer = self
        return rec
    }()
    
    
}

// MARK: -FirebaseRecognizer

private final class STFirebaseRecognizer: Recognizer {
    
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
