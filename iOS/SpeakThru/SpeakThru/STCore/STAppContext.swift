//
//  STAppContext.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

final class STAppContext: NSObject {
    
    override init() {
        super.init()
        if database.isApplicationRunsFirstTime() {
            guard let code = Locale.current.languageCode else { return }
            database.set(targetLang: code)
        }
    }
    
    private let firebaseManager = STFirebaseManager()
    let database = STDatabaseImpl()
}
