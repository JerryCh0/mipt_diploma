//
//  STMainVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class STMainVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.cameraController.delegate = self
        self.firebaseRecognizer.delegate = self
        
        self.settingsButton.set {
            Analytics.logEvent("settings_button_tap", parameters: nil)
            self.view.isHidden = true
            STApp.shared.routing.open(screen: .settings)
        }
        
        self.bookmarksButton.set {
            Analytics.logEvent("bookmarks_button_tap", parameters: nil)
            self.view.isHidden = true
            STApp.shared.routing.open(screen: .bookmarks)
        }
        
        self.shutterButton.set {
            Analytics.logEvent("shutter_button_tap", parameters: nil)
            self.cameraController.capturePhoto()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        STApp.shared.database.remove(listener: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.cameraController.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        STApp.shared.database.add(listener: self)
        
//        let translation = STTranslation(
//            imageToTranslate: UIImage(named: "SampleTranslation")!,
//            translatedText: "Путь к выходу",
//            isSaved: false,
//            fromLanguage: "EN",
//            toLanguage: "RU"
//        )
//        self.translation = translation
//        translationView.set(translation: translation)
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        settingsButton.frame = CGRect(
            x: view.frame.width - STLayout.settingsButtonSize.width - STLayout.boundOffset,
            y: view.frame.height - STLayout.settingsButtonSize.height - STLayout.boundOffset - view.safeAreaInsets.bottom,
            width: STLayout.settingsButtonSize.width,
            height: STLayout.settingsButtonSize.height
        )
        
        bookmarksButton.frame = CGRect(
            x: STLayout.boundOffset,
            y: settingsButton.frame.minY,
            width: STLayout.bookmarksButtonSize.width,
            height: STLayout.bookmarksButtonSize.height
        )
        
        shutterButton.frame = CGRect(
            x: view.frame.midX - STLayout.shutterButtonSize.width / 2,
            y: settingsButton.frame.maxY - STLayout.shutterButtonSize.height,
            width: STLayout.shutterButtonSize.width,
            height: STLayout.shutterButtonSize.height
        )
        
        let translationViewTop = STLayout.translationViewInsets.top + view.safeAreaInsets.top
        
        translationView.frame = CGRect(
            x: STLayout.translationViewInsets.left,
            y: translationViewTop,
            width: view.frame.width - STLayout.translationViewInsets.left - STLayout.translationViewInsets.right,
            height: shutterButton.frame.minY - STLayout.translationViewInsets.bottom - translationViewTop
        )
        
        translationView.set(previewLayer: cameraController.getPreviewLayer())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraController.stop()
    }
    
    private func addSubviews() {
        let subviews = [settingsButton, bookmarksButton, shutterButton, translationView]
        subviews.forEach(view.addSubview)
    }
    
    private let settingsButton = STButton(
        icon: STStyleKit.settingsIcon,
        callback: {}
    )
    
    private let bookmarksButton = STButton(
        icon: STStyleKit.bookmarksIcon,
        callback: {}
    )
    
    private let shutterButton = STButton(
        icon: STStyleKit.shutterImage,
        callback: {}
    )
    
    private let translationView = STTranslationView()
    private var translation: STTranslation?
    
    private let listenerId = UUID().uuidString
    
    private let cameraController = STCameraController()
    private let firebaseRecognizer = STFirebaseRecognizer()
}

extension STMainVC: STDatabaseListener {
    
    func id() -> String {
        return listenerId
    }
    
    func onDataUpdated() {
        let translations = STApp.shared.database.getAllTranslations()
        guard let trans = translation else { return }
        if !translations.keys.contains(trans.id) {
            trans.isSaved = false
            translationView.set(translation: trans)
        }
    }
}

extension STMainVC: STCameraControllerDelegate {
    func didCapture(photo: UIImage) {
        translationView.beginRecognition(with: photo)
        firebaseRecognizer.recognize(from: photo)
    }
}

extension STMainVC: STFirebaseRecognizerDelegate {
    func onRecognized(text: String, lang: String) {
        return
    }
}

private struct STLayout {
    
    static let boundOffset = CGFloat(16)
    static let settingsButtonSize = CGSize(width: 32, height: 32)
    static let bookmarksButtonSize = CGSize(width: 32, height: 32)
    static let shutterButtonSize = CGSize(width: 52, height: 52)
    
    static let translationViewInsets = UIEdgeInsets(top: 40, left: 20, bottom: 32, right: 20)
    
}
