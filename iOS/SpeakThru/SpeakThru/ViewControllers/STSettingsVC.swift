//
//  STSettingsVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 31/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

class STSettingsVC: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.closeButton.set { [unowned self] in
            self.dismiss(animated: true, completion: nil)
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
        closeButton.frame = CGRect(
            x: view.frame.width - STLayout.closeButtonSize.width - STLayout.boundOffset,
            y: STLayout.boundOffset + STLayout.closeButtonSize.height,
            width: STLayout.closeButtonSize.width,
            height: STLayout.closeButtonSize.height)
    }
    
    private func setupUI() {
        
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [closeButton]
        subviews.forEach(view.addSubview)
    }
    
    private let closeButton = STButton(
        icon: STStyleKit.closeIcon,
        callback: {}
    )

}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let closeButtonSize = CGSize(width: 32, height: 24)
}
