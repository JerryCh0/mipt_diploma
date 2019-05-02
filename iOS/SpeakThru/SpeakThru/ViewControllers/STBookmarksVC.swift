//
//  STBookmarksVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 24/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Koloda

final class STBookmarksVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.backButton.set { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        self.rewindButton.set { [unowned self] in
            self.kolodaView.revertAction()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        STApp.shared.database.add(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        STApp.shared.database.remove(listener: self)
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
        
        rewindButton.frame = CGRect(
            x: view.frame.width - view.safeAreaInsets.right - STLayout.rewindButtonSize.width - STLayout.boundOffset,
            y: backButton.frame.minY,
            width: STLayout.rewindButtonSize.width,
            height: STLayout.rewindButtonSize.height
        )
        
        titleLabel.frame = CGRect(
            x: view.frame.midX - STLayout.titleLabelSize.width / 2,
            y: backButton.frame.maxY - STLayout.titleLabelSize.height,
            width: STLayout.titleLabelSize.width,
            height: STLayout.titleLabelSize.height
        )
        
        let kolodaTop = titleLabel.frame.maxY + STLayout.kolodaInsets.top
        
        kolodaView.frame = CGRect(
            x: view.safeAreaInsets.left + STLayout.kolodaInsets.left,
            y: kolodaTop,
            width: view.frame.width - (STLayout.kolodaInsets.left + STLayout.kolodaInsets.right),
            height: view.frame.height - STLayout.kolodaInsets.bottom - kolodaTop
        )
        
        placeholderLabel.frame = CGRect(
            x: view.frame.midX - STLayout.placeholderLabelSize.width / 2,
            y: view.frame.midY - STLayout.placeholderLabelSize.height / 2,
            width: STLayout.placeholderLabelSize.width,
            height: STLayout.placeholderLabelSize.height
        )
    }
    
    private func setupUI() {
        // Title
        titleLabel.font = STStyleKit.rationaleFont(of: 18)
        titleLabel.text = "Сохранённые переводы"
        titleLabel.textColor = STColor.neonBlue
        titleLabel.textAlignment = .center
        
        // Placeholder
        placeholderLabel.font = STStyleKit.rationaleFont(of: 16)
        updatePlaceholderText()
        placeholderLabel.textColor = STColor.neonBlue
        placeholderLabel.textAlignment = .center
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [placeholderLabel, backButton, titleLabel, kolodaView, rewindButton]
        subviews.forEach(view.addSubview)
    }
    
    private func updatePlaceholderText() {
        placeholderLabel.text = self.kolodaNumberOfCards(kolodaView) > 0
            ? "Нажмите ⟲, чтобы листать назад"
            : "Пока здесь пусто"
    }
    
    private let backButton = STButton(
        icon: STStyleKit.backIcon,
        callback: {}
    )
    
    private let rewindButton = STButton(
        icon: STStyleKit.rewindIcon,
        callback: {}
    )
    
    private let titleLabel = UILabel()
    private let placeholderLabel = UILabel()
    private let kolodaView = KolodaView()
    
    private let listenerId = UUID().uuidString
}

extension STBookmarksVC: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        return
    }
}

extension STBookmarksVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        let translations = STApp.shared.database.getAllTranslations()
        return translations.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = STTranslationView()
        let translations = Array(STApp.shared.database.getAllTranslations().values)
        view.set(translation: translations[index])
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
    
}

extension STBookmarksVC: STDatabaseListener {
    func onDataUpdated() {
        updatePlaceholderText()
        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
    }
    
    func id() -> String {
        return listenerId
    }
}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let closeButtonSize = CGSize(width: 24, height: 24)
    static let rewindButtonSize = CGSize(width: 24, height: 24)
    static let titleLabelSize = CGSize(width: 256, height: 24)
    static let placeholderLabelSize = CGSize(width: 256, height: 24)
    
    static let kolodaInsets = UIEdgeInsets(top: 20, left: 20, bottom: 32, right: 20)
}
