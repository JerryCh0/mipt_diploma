//
//  STSettingVC.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 03/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STSettingVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(title: String, items: [STSettingsCellViewModel]) {
        self.titleText = title
        self.items = items
        super.init(nibName: nil, bundle: nil)
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
            width: STLayout.backButtonSize.width,
            height: STLayout.backButtonSize.height
        )
        
        titleLabel.frame = CGRect(
            x: view.frame.midX - STLayout.titleLabelSize.width / 2,
            y: backButton.frame.maxY - STLayout.titleLabelSize.height,
            width: STLayout.titleLabelSize.width,
            height: STLayout.titleLabelSize.height
        )
        
        tableView.frame = CGRect(
            x: view.safeAreaInsets.left + STLayout.boundOffset,
            y: backButton.frame.maxY + STLayout.boundOffset,
            width: view.frame.width - (view.safeAreaInsets.left + view.safeAreaInsets.right + 2 * STLayout.boundOffset),
            height: view.frame.height - (2 * STLayout.boundOffset + backButton.frame.maxY)
        )
    }
    
    private func setupUI() {
        
        // Title
        titleLabel.font = STStyleKit.rationaleFont(of: 18)
        titleLabel.text = titleText
        titleLabel.textColor = STColor.neonBlue
        titleLabel.textAlignment = .center
        
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
        let subviews = [backButton, titleLabel, tableView]
        subviews.forEach(view.addSubview)
    }
    
    private let backButton = STButton(
        icon: STStyleKit.backIcon,
        callback: {}
    )
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
    private let titleText: String
    private let items: [STSettingsCellViewModel]
}

extension STSettingVC: UITableViewDataSource {
    
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

extension STSettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section < items.count else { fatalError() }
        let item = items[indexPath.section]
        switch item {
        case let .detailedCell(_, _, action):
            action()
        case let .textCell(_, action):
            action()
        }
    }
}

private struct STLayout {
    static let boundOffset = CGFloat(16)
    static let backButtonSize = CGSize(width: 24, height: 24)
    static let titleLabelSize = CGSize(width: 256, height: 24)
}
