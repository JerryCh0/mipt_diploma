//
//  STTranslationView.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STTranslationView: UIView {
    
    init(with translation: STTranslation?) {
        guard translation == nil else { fatalError() }
        super.init(frame: CGRect.zero)
        addSubviews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func setupUI() {
        
        photoImageView.layer.cornerRadius = STLayout.cornerRadius
        backgroundBubble.layer.cornerRadius = STLayout.cornerRadius
        translationTextView.layer.cornerRadius = STLayout.cornerRadius
        
        photoImageView.backgroundColor = .white
        
        backgroundBubble.backgroundColor = STColor.greyBlue
        
        translationTextView.backgroundColor = .black
        translationTextView.textColor = STColor.neonBlue
        translationTextView.isEditable = false
        translationTextView.isSelectable = false
        
        bookmarkButton.setImage(STStyleKit.saveIcon, for: .normal)
        copyButton.setImage(STStyleKit.copyIcon, for: .normal)
        
        arrowImageView.image = STStyleKit.arrowImage
        
        fromLanguageLabel.textColor = STColor.neonBlue
        fromLanguageLabel.font = STStyleKit.rationaleFont(of: 18)
        
        toLanguageLabel.textColor = STColor.neonBlue
        toLanguageLabel.font = STStyleKit.rationaleFont(of: 18)
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
            photoImageView
        ]
        
        subviews.forEach(addSubview)
    }
    
    private let photoImageView = UIImageView()
    private let backgroundBubble = UIView()
    private let translationTextView = UITextView()
    private let bookmarkButton = UIButton()
    private let copyButton = UIButton()
    private let fromLanguageLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let toLanguageLabel = UILabel()
    
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
    static let langSize = CGSize(width: 18, height: 21)
    static let arrowSize = CGSize(width: 43, height: 5)
    
}
