//
//  STRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import Firebase

private let TypeToString = [
    RecognizerType.firebase : "Firebase",
    RecognizerType.myOwn : "Собственный"
]

func allRecognizers() -> [RecognizerType] {
    return Array(TypeToString.keys)
}

func string(from type: RecognizerType) -> String {
    return TypeToString[type] ?? ""
}

protocol STRecognizerDelegate: class {
    func onRecognized(from photo: UIImage, text: String, lang: String)
}

enum RecognizerType {
    case firebase
    case myOwn
}

private protocol Recognizer: class {
    func recognize(from image: UIImage)
}

final class STRecognizer: Recognizer, STRecognizerDelegate {
    
    func recognize(from image: UIImage) {
        switch type {
        case .firebase:
            firebaseRecognizer.recognize(from: image)
        case .myOwn:
            myOwnRecognizer.recognize(from: image)
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
    private lazy var myOwnRecognizer: STFirebaseRecognizer = {
        let rec = STFirebaseRecognizer()
        rec.coreRecognizer = self
        return rec
    }()
}

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
