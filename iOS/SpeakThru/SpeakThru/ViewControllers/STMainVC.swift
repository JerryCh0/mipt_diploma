//
//  STMainVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics

private enum MainVCState {
    case capturing
    case recognizing
    case captured
}

final class STMainVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.cameraController.delegate = self
        self.recognizer.delegate = self
        
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
            switch self.state {
            case .capturing:
                self.cameraController.capturePhoto()
                self.state = .recognizing
            case .recognizing:
                return
            case .captured:
                self.translationView.continueCapturing()
                self.state = .capturing
            }
            
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
        recognizer.type = STApp.shared.database.getRecognizerType()
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        shutterButton.frame = CGRect(
            x: view.frame.midX - STLayout.shutterButtonSize.width / 2,
            y: view.frame.height - STLayout.shutterButtonSize.height - STLayout.boundOffset - view.safeAreaInsets.bottom,
            width: STLayout.shutterButtonSize.width,
            height: STLayout.shutterButtonSize.height
        )
        
        settingsButton.frame = CGRect(
            x: view.frame.width - STLayout.settingsButtonSize.width - STLayout.boundOffset,
            y: shutterButton.frame.midY - STLayout.settingsButtonSize.height / 2,
            width: STLayout.settingsButtonSize.width,
            height: STLayout.settingsButtonSize.height
        )
        
        bookmarksButton.frame = CGRect(
            x: STLayout.boundOffset,
            y: settingsButton.frame.minY,
            width: STLayout.bookmarksButtonSize.width,
            height: STLayout.bookmarksButtonSize.height
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
    private let recognizer = STRecognizer()
    
    private var state: MainVCState = .capturing {
        willSet {
            switch newValue {
            case .capturing:
                shutterButton.setImage(STStyleKit.shutterImage, for: .normal)
            case .recognizing:
                shutterButton.setImage(STStyleKit.shutterImage, for: .normal)
            case .captured:
                shutterButton.setImage(STStyleKit.crossImage, for: .normal)
            }
        }
    }
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
        recognizer.type = STApp.shared.database.getRecognizerType()
    }
}

extension STMainVC: STCameraControllerDelegate {
    func didCapture(photo: UIImage) {
        translationView.beginRecognition(with: photo)
        recognizer.recognize(from: photo)
    }
}

extension STMainVC: STRecognizerDelegate {
    
    func onRecognized(from photo: UIImage, text: String, lang: String) {
        let targetLang = STApp.shared.database.getTargetLang()
        STGoogleTranslator.shared.translate(text, targetLang, lang) { (translatedText, error) in
            guard error == nil, let trText = translatedText else { return }
            let translation = STTranslation(
                imageToTranslate: photo,
                translatedText: trText,
                isSaved: false,
                fromLanguage: lang.prefix(2).uppercased(),
                toLanguage: targetLang.uppercased()
            )
            
            DispatchQueue.main.async {
                self.translation = translation
                self.translationView.set(translation: translation)
                self.translationView.stopRecognition()
                self.state = .captured
            }
        }
    }
}

private struct STLayout {
    
    static let boundOffset = CGFloat(16)
    static let settingsButtonSize = CGSize(width: 32, height: 32)
    static let bookmarksButtonSize = CGSize(width: 32, height: 32)
    static let shutterButtonSize = CGSize(width: 52, height: 52)
    
    static let translationViewInsets = UIEdgeInsets(top: 40, left: 20, bottom: 32, right: 20)
    
}
