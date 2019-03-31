//
//  STButton.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

typealias STButtonCallback = () -> Void

final class STButton: UIButton {
    
    init(icon: UIImage, callback: @escaping STButtonCallback) {
        callback_ = callback
        super.init(frame: .zero)
        setImage(icon, for: .normal)
        addTarget(self, action: #selector(self.callback), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(callback: @escaping STButtonCallback) {
        callback_ = callback
    }
    
    @objc private func callback() {
        callback_()
    }
    
    private var callback_: STButtonCallback
}
