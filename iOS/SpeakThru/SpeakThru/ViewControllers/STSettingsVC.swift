//
//  STSettingsVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 31/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STSettingsVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.backButton.set { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backButton.frame = CGRect(
            x: STLayout.boundOffset + view.safeAreaInsets.left,
            y: STLayout.boundOffset + view.safeAreaInsets.top,
            width: STLayout.closeButtonSize.width,
            height: STLayout.closeButtonSize.height
        )
        
        titleLabel.frame = CGRect(
            x: view.frame.midX - STLayout.titleLabelSize.width / 2,
            y: backButton.frame.maxY - STLayout.titleLabelSize.height,
            width: STLayout.titleLabelSize.width,
            height: STLayout.titleLabelSize.height
        )
        
        aboutButton.frame = CGRect(
            x: view.frame.midX - STLayout.aboutButtonSize.width / 2,
            y: view.frame.maxY - view.safeAreaInsets.bottom - STLayout.boundOffset - STLayout.aboutButtonSize.height,
            width: STLayout.aboutButtonSize.width,
            height: STLayout.aboutButtonSize.height
        )
    }
    
    private func setupUI() {
        
        // Title
        titleLabel.font = STStyleKit.rationaleFont(of: 18)
        titleLabel.text = "Настройки"
        titleLabel.textColor = STColor.neonBlue
        titleLabel.textAlignment = .center
        
        // About button
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : STColor.neonBlue,
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            NSAttributedString.Key.font : STStyleKit.rationaleFont(of: 12)
        ]
        
        aboutButton.setAttributedTitle(
            NSMutableAttributedString(string: "О приложении", attributes: attributes),
            for: .normal
        )
        
        aboutButton.addTarget(
            self,
            action: #selector(aboutButtonHandler),
            for: .touchUpInside
        )
        
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [backButton, titleLabel, aboutButton]
        subviews.forEach(view.addSubview)
    }
    
    @objc private func aboutButtonHandler() {
        STApp.shared.routing.open(screen: .about)
    }
    
    private let backButton = STButton(
        icon: STStyleKit.backIcon,
        callback: {}
    )
    
    private let titleLabel = UILabel()
    private let aboutButton = UIButton()

}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let closeButtonSize = CGSize(width: 24, height: 24)
    static let aboutButtonSize = CGSize(width: 88, height: 14)
    static let titleLabelSize = CGSize(width: 108, height: 24)
}
