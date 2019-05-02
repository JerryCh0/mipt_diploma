//
//  STFirebaseRecognizer.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import Firebase

protocol STFirebaseRecognizerDelegate: class {
    func onRecognized(from photo: UIImage, text: String, lang: String)
}

final class STFirebaseRecognizer {
    
    func recognize(from image: UIImage) {
        let vImage = VisionImage(image: image)
        cloudTextRecognizer.process(vImage) { text, error in
            guard error == nil, let result = text else { return }
            
            self.delegate?.onRecognized(from: image, text: result.text, lang: result.blocks.first?.recognizedLanguages.first?.languageCode ?? "")
        }
    }
    
    
    private let vision = Vision.vision()
    
    private lazy var deviceTextRecognizer = vision.onDeviceTextRecognizer()
    private lazy var cloudTextRecognizer = vision.cloudTextRecognizer()
    
    weak var delegate: STFirebaseRecognizerDelegate?
}
