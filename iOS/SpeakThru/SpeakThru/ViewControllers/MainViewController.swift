//
//  MainViewController.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 08/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
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
            height: STLayout.settingsButtonSize.height)
    }
    
    private func setupUI() {
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [settingsButton]
        subviews.forEach(view.addSubview)
    }
    
    private let settingsButton = STButton(
        icon: STDesign.settingsIcon,
        callback: { STApp.shared.routing.open(screen: .settings) }
    )
}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let settingsButtonSize = CGSize(width: 32, height: 32)
}

private struct STDesign {
    static let settingsIcon = UIImage(named: "STButtonSettings")!
}
