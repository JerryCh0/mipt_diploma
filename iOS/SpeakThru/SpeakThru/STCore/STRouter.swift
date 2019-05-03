//
//  STRouter.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class STRouter: NSObject {
    
    init(window: UIWindow) {
        let mainVC = STMainVC()
        let navigationVC = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        self.window = window
        super.init()
    }
    
    private let window: UIWindow
    
    private lazy var aboutVC: UIViewController = {
        let storyboard = UIStoryboard(name: "AboutScreen", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AboutVC")
    }()
    
}

extension STRouter: STRouting {
    
    func open(screen: STScreen) {
        switch screen {
        case .settings:
            Analytics.logEvent("open_settings", parameters: nil)
            guard let navigationVC = window.rootViewController as? UINavigationController else { return }
            let settingsVC = STSettingsVC()
            navigationVC.pushViewController(settingsVC, animated: true)
        case .bookmarks:
            Analytics.logEvent("open_bookmarks", parameters: nil)
            guard let navigationVC = window.rootViewController as? UINavigationController else { return }
            let bookmarksVC = STBookmarksVC()
            navigationVC.pushViewController(bookmarksVC, animated: true)
        case .about:
            Analytics.logEvent("open_about", parameters: nil)
            guard let navigationVC = window.rootViewController as? UINavigationController else { return }
            navigationVC.pushViewController(aboutVC, animated: true)
        case .recognitionModel:
            Analytics.logEvent("open_recognition_model", parameters: nil)
            guard let navigationVC = window.rootViewController as? UINavigationController else { return }
            let recognitionVC = STSettingVC(title: "Модель распознавания", items: [])
            navigationVC.pushViewController(recognitionVC, animated: true)
        case .targetLanguage:
            Analytics.logEvent("open_target_language", parameters: nil)
            guard let navigationVC = window.rootViewController as? UINavigationController else { return }
            let languageVC = STSettingVC(title: "Целевой язык", items: [])
            navigationVC.pushViewController(languageVC, animated: true)
        default:
            assert(false, "Trying to make unimplemented routing")
        }
    }
    
}
