//
//  STApp.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import Toast_Swift

final class STApp {
    
    private init() {
        self.window = UIWindow()
        self.router = STRouter(window: self.window)
        ToastManager.shared.isTapToDismissEnabled = true
    }
    
    var routing: STRouting {
        return router
    }
    
    var database: STDatabase {
        return context.database
    }
    
    private let context = STAppContext()
    private let router: STRouter
    let window: UIWindow
    
    static let shared = STApp()
}
