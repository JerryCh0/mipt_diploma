//
//  STMainVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STMainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        settingsButton.frame = CGRect(
            x: view.frame.width - STLayout.settingsButtonSize.width - STLayout.boundOffset,
            y: view.frame.height - STLayout.settingsButtonSize.height - STLayout.boundOffset,
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
    }
    
    private func setupUI() {
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [settingsButton, bookmarksButton, shutterButton]
        subviews.forEach(view.addSubview)
    }
    
    private let settingsButton = STButton(
        icon: STStyleKit.settingsIcon,
        callback: { STApp.shared.routing.open(screen: .settings) }
    )
    
    private let bookmarksButton = STButton(
        icon: STStyleKit.bookmarksIcon,
        callback: { STApp.shared.routing.open(screen: .bookmarks) }
    )
    
    private let shutterButton = STButton(
        icon: STStyleKit.shutterImage,
        callback: { print("Photo shot")  }
    )
}

private struct STLayout {
    
    static let boundOffset = CGFloat(16)
    static let settingsButtonSize = CGSize(width: 32, height: 32)
    static let bookmarksButtonSize = CGSize(width: 32, height: 32)
    static let shutterButtonSize = CGSize(width: 52, height: 52)
    
}
