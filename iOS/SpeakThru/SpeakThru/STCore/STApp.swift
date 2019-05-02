//
//  STApp.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import Toast_Swift

private let GOOGLE_API_KEY = "AIzaSyCC0Euft9AJ1NDdIct62HMd-sX4vk1qMI0"

final class STApp {
    
    private init() {
        self.window = UIWindow()
        self.router = STRouter(window: self.window)
        ToastManager.shared.isTapToDismissEnabled = true
        STGoogleTranslator.shared.start(with: GOOGLE_API_KEY)
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
