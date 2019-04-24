//
//  STTranslation.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import UIKit

final class STTranslation: NSObject {
    
    init(imageToTranslate: UIImage,
         translatedText: String,
         isSaved: Bool,
         fromLanguage: String,
         toLanguage: String) {
        self.imageToTranslate = imageToTranslate
        self.translatedText = translatedText
        self.isSaved = isSaved
        self.fromLanguage = fromLanguage
        self.toLanguage = toLanguage
        
        super.init()
    }
    
    
    private let imageToTranslate: UIImage
    
    private let translatedText: String
    
    private let isSaved: Bool
    
    private let fromLanguage: String
    private let toLanguage: String
    
}
