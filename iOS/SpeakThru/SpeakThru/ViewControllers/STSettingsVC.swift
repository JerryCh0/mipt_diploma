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
        STApp.shared.database.add(listener: self)
        setupUI()
    }
    
    deinit {
        STApp.shared.database.remove(listener: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = false
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
        
        tableView.frame = CGRect(
            x: view.safeAreaInsets.left + STLayout.boundOffset,
            y: backButton.frame.maxY + STLayout.boundOffset,
            width: view.frame.width - (view.safeAreaInsets.left + view.safeAreaInsets.right + 2 * STLayout.boundOffset),
            height: aboutButton.frame.minY - 2 * STLayout.boundOffset - backButton.frame.maxY
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
        
        // Table view
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(STSettingCell.self, forCellReuseIdentifier: STSettingCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubviews()
    }
    
    private func addSubviews() {
        let subviews = [backButton, titleLabel, aboutButton, tableView]
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
    private let tableView = UITableView()
    
    private let listenerId = UUID().uuidString

    private lazy var items = STSettingsViewModelFactory.buildMainSettings()
}

extension STSettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < items.count else { return UITableViewCell() }
        let item = items[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: STSettingCell.reuseIdentifier, for: indexPath) as! STSettingCell
        cell.model = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.backgroundColor = .black
        return hView
    }
}

extension STSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section < items.count else { fatalError() }
        let item = items[indexPath.section]
        switch item {
        case let .detailedCell(_, _, action):
            view.isHidden = true
            action()
        case let .textCell(_, action):
            action()
        }
    }
}

extension STSettingsVC: STDatabaseListener {
    func onDataUpdated() {
        items = STSettingsViewModelFactory.buildMainSettings()
        tableView.reloadData()
    }
    
    func id() -> String {
        return listenerId
    }
}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let closeButtonSize = CGSize(width: 24, height: 24)
    static let aboutButtonSize = CGSize(width: 88, height: 14)
    static let titleLabelSize = CGSize(width: 108, height: 24)
}
