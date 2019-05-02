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
    
    static let nullId = "NULL"
    
    init(id: String = STTranslation.nullId,
         imageToTranslate: UIImage = UIImage(),
         translatedText: String = "",
         isSaved: Bool = false,
         fromLanguage: String = "",
         toLanguage: String = "") {
        
        self.id = id == STTranslation.nullId ? UUID().uuidString : id
        self.imageToTranslate = imageToTranslate
        self.translatedText = translatedText
        self.isSaved = isSaved
        self.fromLanguage = fromLanguage
        self.toLanguage = toLanguage
        
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let imageToTranslate = aDecoder.decodeObject(forKey: "image") as! UIImage
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let saved = aDecoder.decodeBool(forKey: "saved")
        let fromLang = aDecoder.decodeObject(forKey: "from") as! String
        let toLang = aDecoder.decodeObject(forKey: "to") as! String
        self.init(
            id: id,
            imageToTranslate: imageToTranslate,
            translatedText: text,
            isSaved: saved,
            fromLanguage: fromLang,
            toLanguage: toLang
        )
    }
    
    let id: String
    let imageToTranslate: UIImage
    let translatedText: String
    var isSaved: Bool
    let fromLanguage: String
    let toLanguage: String
    
}

extension STTranslation: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imageToTranslate, forKey: "image")
        aCoder.encode(translatedText, forKey: "text")
        aCoder.encode(isSaved, forKey: "saved")
        aCoder.encode(fromLanguage, forKey: "from")
        aCoder.encode(toLanguage, forKey: "to")
    }
    
}
