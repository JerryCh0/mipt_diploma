//
//  STTranslationView.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import Toast_Swift
import FirebaseAnalytics
import AVFoundation

final class STTranslationView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(translation: STTranslation) {
        self.translation = translation
        
        photoImageView.image = translation.imageToTranslate
        translationTextView.text = translation.translatedText
        fromLanguageLabel.text = translation.fromLanguage
        toLanguageLabel.text = translation.toLanguage
        bookmarkButton.setImage(
            translation.isSaved ? STStyleKit.savedIcon : STStyleKit.saveIcon,
            for: .normal
        )
    }
    
    func set(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        photoImageView.layer.addSublayer(previewLayer)
    }
    
    func beginRecognition(with image: UIImage) {
        subviewsToHide.forEach { $0.isHidden = true}
        previewLayer?.isHidden = true
        photoImageView.image = image
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopRecognition() {
        subviewsToHide.forEach { $0.isHidden = false }
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func continueCapturing() {
        stopRecognition()
        set(translation: STTranslation())
        self.translation = nil
        previewLayer?.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height
        let width = bounds.width
        let halfWidth = width / 2
        let maxY = bounds.maxY
        
        let photoHeight = STLayout.photoHeightPercentage * height
        let bubbleHeight = STLayout.bubbleHeightPercentage * height
        let textViewWidth = STLayout.textViewWidthPercentage * width
        let textViewHeight = STLayout.textViewHeightPercentage * bubbleHeight
        
        photoImageView.frame = CGRect(x: 0, y: 0, width: width, height: photoHeight)
        previewLayer?.frame = photoImageView.frame
        backgroundBubble.frame = CGRect(x: 0, y: maxY - bubbleHeight, width: width, height: bubbleHeight)
        
        bookmarkButton.frame = CGRect(
            x: STLayout.buttonsOffset,
            y: height - STLayout.buttonsOffset - STLayout.buttonSize.height,
            width: STLayout.buttonSize.width,
            height: STLayout.buttonSize.height
        )
        
        copyButton.frame = CGRect(
            x: width - STLayout.buttonsOffset - STLayout.buttonSize.width,
            y: height - STLayout.buttonsOffset - STLayout.buttonSize.height,
            width: STLayout.buttonSize.width,
            height: STLayout.buttonSize.height
        )
        
        translationTextView.frame = CGRect(
            x: halfWidth - textViewWidth / 2,
            y: photoImageView.frame.maxY + STLayout.boundOffset,
            width: textViewWidth,
            height: textViewHeight
        )
        
        arrowImageView.frame = CGRect(
            x: halfWidth - STLayout.arrowSize.width / 2,
            y: height - STLayout.boundOffset - STLayout.arrowSize.height,
            width: STLayout.arrowSize.width,
            height: STLayout.arrowSize.height
        )
        
        fromLanguageLabel.frame = CGRect(
            x: arrowImageView.frame.minX - STLayout.langToArrowOffset - STLayout.langSize.width,
            y: arrowImageView.frame.midY - STLayout.langSize.height / 2,
            width: STLayout.langSize.width,
            height: STLayout.langSize.height
        )
        
        toLanguageLabel.frame = CGRect(
            x: arrowImageView.frame.maxX + STLayout.langToArrowOffset,
            y: fromLanguageLabel.frame.minY,
            width: STLayout.langSize.width,
            height: STLayout.langSize.height
        )
        
        activityIndicator.frame = CGRect(
            x: translationTextView.frame.midX - STLayout.activityIndicatorSize.width / 2,
            y: translationTextView.frame.midY - STLayout.activityIndicatorSize.height / 2,
            width: STLayout.activityIndicatorSize.width,
            height: STLayout.activityIndicatorSize.height
        )
    }
    
    private func setupUI() {
        
        photoImageView.layer.cornerRadius = STLayout.cornerRadius
        backgroundBubble.layer.cornerRadius = STLayout.cornerRadius
        translationTextView.layer.cornerRadius = STLayout.cornerRadius
        
        photoImageView.backgroundColor = .white
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.masksToBounds = true
        
        backgroundBubble.backgroundColor = STColor.greyBlue
        
        translationTextView.backgroundColor = .black
        translationTextView.textColor = STColor.neonBlue
        translationTextView.textAlignment = .center
        translationTextView.isEditable = false
        translationTextView.isSelectable = false
        
        bookmarkButton.setImage(STStyleKit.saveIcon, for: .normal)
        copyButton.setImage(STStyleKit.copyIcon, for: .normal)
        
        bookmarkButton.addTarget(self, action: #selector(onBookmarkTap), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        
        arrowImageView.image = STStyleKit.arrowImage
        
        fromLanguageLabel.textColor = STColor.neonBlue
        fromLanguageLabel.textAlignment = .center
        fromLanguageLabel.font = STStyleKit.rationaleFont(of: 18)
        
        toLanguageLabel.textColor = STColor.neonBlue
        toLanguageLabel.textAlignment = .center
        toLanguageLabel.font = STStyleKit.rationaleFont(of: 18)
        
        activityIndicator.color = STColor.neonBlue
        activityIndicator.isHidden = true
    }
    
    private func addSubviews() {
        // Order is necessary
        let subviews = [
            backgroundBubble,
            translationTextView,
            bookmarkButton,
            fromLanguageLabel,
            arrowImageView,
            toLanguageLabel,
            copyButton,
            photoImageView,
            activityIndicator
        ]
        
        subviews.forEach(addSubview)
    }
    
    @objc private func copyToClipboard() {
        Analytics.logEvent(
            "copy_to_pasteboard",
            parameters: ["translation_id" : translation?.id ?? "none"]
        )
        
        guard let trans = translation else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = trans.translatedText
        
        makeToast(
            "Перевод скопирован",
            duration: 2.0,
            position: .center,
            title: nil,
            image: nil,
            style: STStyleKit.toastStyle,
            completion: nil
        )
    }
    
    @objc private func onBookmarkTap() {
        Analytics.logEvent(
            (translation?.isSaved ?? false) ? "delete_translation" : "save_translation",
            parameters: ["translation_id" : translation?.id ?? "none"]
        )
        guard let trans = translation else { return }
        if trans.isSaved {
            if STApp.shared.database.removeTranslation(with: trans.id) {
                bookmarkButton.setImage(STStyleKit.saveIcon, for: .normal)
            }
        } else {
            trans.isSaved = true
            if STApp.shared.database.store(translation: trans) {
                bookmarkButton.setImage(STStyleKit.savedIcon, for: .normal)
                makeToast(
                    "Перевод сохранён",
                    duration: 2.0,
                    position: .center,
                    title: nil,
                    image: nil,
                    style: STStyleKit.toastStyle,
                    completion: nil
                )
            } else {
                trans.isSaved = false
            }
        }
    }
    
    private let photoImageView = UIImageView()
    private let backgroundBubble = UIView()
    private let translationTextView = UITextView()
    private let bookmarkButton = UIButton()
    private let copyButton = UIButton()
    private let fromLanguageLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let toLanguageLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    private lazy var subviewsToHide =
        [bookmarkButton, copyButton, fromLanguageLabel, toLanguageLabel, arrowImageView]
    
    private var translation: STTranslation?
    private var previewLayer: CALayer?
}

private struct STLayout {
    
    static let photoHeightPercentage: CGFloat = 0.74
    static let bubbleHeightPercentage: CGFloat = 0.39
    static let textViewWidthPercentage: CGFloat = 0.87
    static let textViewHeightPercentage: CGFloat = 0.30
    
    static let cornerRadius: CGFloat = 16
    static let boundOffset: CGFloat = 16
    static let langToArrowOffset: CGFloat = 12
    static let buttonsOffset: CGFloat = 10
    
    static let buttonSize = CGSize(width: 24, height: 24)
    static let langSize = CGSize(width: 20, height: 21)
    static let arrowSize = CGSize(width: 43, height: 5)
    
    static let activityIndicatorSize = CGSize(width: 20, height: 20)
    
}
