//
//  STFirebaseManager.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Firebase

final class STFirebaseManager: NSObject {
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }
    
}
