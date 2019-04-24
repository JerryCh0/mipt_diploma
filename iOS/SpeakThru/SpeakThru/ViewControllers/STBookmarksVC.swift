//
//  STBookmarksVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class STBookmarksVC: UIViewController {
    
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
            y: STLayout.boundOffset + STLayout.closeButtonSize.height + view.safeAreaInsets.top,
            width: STLayout.closeButtonSize.width,
            height: STLayout.closeButtonSize.height
        )
        
        titleLabel.frame = CGRect(
            x: view.frame.midX - STLayout.titleLabelSize.width / 2,
            y: backButton.frame.maxY - STLayout.titleLabelSize.height,
            width: STLayout.titleLabelSize.width,
            height: STLayout.titleLabelSize.height
        )
    }
    
    private func setupUI() {
        // Title
        titleLabel.font = STStyleKit.rationaleFont(of: 18)
        titleLabel.text = "Сохранённые переводы"
        titleLabel.textColor = STColor.neonBlue
        titleLabel.textAlignment = .center
        
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [backButton, titleLabel]
        subviews.forEach(view.addSubview)
    }
    
    private let backButton = STButton(
        icon: STStyleKit.backIcon,
        callback: {}
    )
    
    private let titleLabel = UILabel()
}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let closeButtonSize = CGSize(width: 24, height: 24)
    static let titleLabelSize = CGSize(width: 256, height: 24)
}
