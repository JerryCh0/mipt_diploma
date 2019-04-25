//
//  STFirebaseRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import Firebase

struct RecognizedText {
    
}

protocol STFirebaseRecognizerDelegate: class {
    func onRecognized(text: String, lang: String)
}

final class STFirebaseRecognizer {
    
    func recognize(from image: UIImage) {
        let vImage = VisionImage(image: image)
        textRecognizer.process(vImage) { text, error in
            guard error == nil, let result = text else { return }
            
            self.delegate?.onRecognized(text: result.text, lang: result.blocks.first?.recognizedLanguages.first?.languageCode ?? "")
        }
    }
    
    
    private let vision = Vision.vision()
    private lazy var textRecognizer = vision.onDeviceTextRecognizer()
    
    weak var delegate: STFirebaseRecognizerDelegate?
}
