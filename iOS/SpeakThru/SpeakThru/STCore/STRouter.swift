//
//  STRouter.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STRouter: NSObject {
    
    init(window: UIWindow) {
        window.rootViewController = STMainVC()
        window.makeKeyAndVisible()
        self.window = window
        super.init()
    }
    
    private let window: UIWindow
    
}

extension STRouter: STRouting {
    
    func open(screen: STScreen) {
        switch screen {
        case .settings:
            let settingsVC = STSettingsVC()
            window.rootViewController?.present(settingsVC, animated: true, completion: nil)
            print("Settings opened")
        case .bookmarks:
            print("Bookmarks opened")
        default:
            assert(false, "Trying to make unimplemented routing")
        }
    }
    
}
