//
//  Lang.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 06/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

private let CodeToLang = [
    "ru" : "Русский",
    "en" : "Английский",
    "de" : "Немецкий",
    "fr" : "Французский",
    "it" : "Итальянский",
    "es" : "Испанский",
    "zh" : "Китайский",
    "hi" : "Хинди",
    "ar" : "Арабский",
    "pt" : "Португальский",
    "tr" : "Турецкий",
    "ja" : "Японский"
]

func allCodes() -> [String] {
    return Array(CodeToLang.keys)
}

func code(from lang: String) -> String {
    for (key, value) in CodeToLang {
        if value == lang {
            return key
        }
    }
    return ""
}

func lang(from code: String) -> String {
    return CodeToLang[code] ?? ""
}
