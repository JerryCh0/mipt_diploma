//
//  STAboutVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class STAboutVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : STColor.neonBlue,
            NSAttributedString.Key.underlineStyle : 1,
            NSAttributedString.Key.font : STStyleKit.rationaleFont(of: 18)
        ] as [NSAttributedString.Key : Any]
        
        let attributedString = NSAttributedString(
            string: "Написать разработчику",
            attributes: attributes
        )
        
        feedbackButton.setAttributedTitle(attributedString, for: .normal)
        
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        Analytics.logEvent("about_back_button", parameters: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onFeedbackTap(_ sender: UIButton) {
        guard let url = URL(string: "mailto:tkachenko.da@phystech.edu") else { return }
        Analytics.logEvent("about_feedback", parameters: nil)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var feedbackButton: UIButton!
    
}
