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
    
    
    let imageToTranslate: UIImage
    let translatedText: String
    let isSaved: Bool
    let fromLanguage: String
    let toLanguage: String
    
}
