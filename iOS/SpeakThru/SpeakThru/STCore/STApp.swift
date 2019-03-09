//
//  STApp.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STApp {
    
    private init() {
        self.window = UIWindow()
        self.router = STRouter(window: self.window)
    }
    
    var routing: STRouting {
        return router
    }
    
    private let context = STAppContext()
    private let router: STRouter
    let window: UIWindow
    
    static let shared = STApp()
}
