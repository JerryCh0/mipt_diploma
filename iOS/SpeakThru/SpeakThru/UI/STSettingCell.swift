//
//  STSettingCell.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 03/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STSettingCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    init(model: STSettingsCellViewModel) {
        self.model = model
        super.init(style: .default, reuseIdentifier: STSettingCell.reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else { fatalError() }
        let layout = STLayout.build(in: bounds, with: model)
        mainTextLabel.frame = layout.mainTextFrame
        if let dFrame = layout.detailedTextFrame {
            detailedTextLabel.frame = dFrame
        }
    }
    
    override var selectionStyle: UITableViewCell.SelectionStyle {
        set {
            return
        }
        get {
            return .none
        }
    }
    
    private func addSubviews() {
        let subviews = [mainTextLabel, detailedTextLabel]
        subviews.forEach(contentView.addSubview)
    }
    
    private func setupUI() {
        layer.cornerRadius = STLayout.cornerRadius
        backgroundColor = .black
        
        contentView.backgroundColor = STColor.greyBlue
        contentView.layer.cornerRadius = STLayout.cornerRadius
        
        mainTextLabel.textColor = STColor.neonBlue
        detailedTextLabel.textColor = STColor.neonBlue
        
        mainTextLabel.font = STStyleKit.rationaleFont(of: 14)
        detailedTextLabel.font = STStyleKit.rationaleFont(of: 14)
        
        guard let model = self.model else { fatalError() }
        
        switch model {
        case let .detailedCell(mainText, detailedText, _):
            mainTextLabel.text = mainText
            detailedTextLabel.text = detailedText
            
            mainTextLabel.textAlignment = .left
            detailedTextLabel.textAlignment = .right
            
            detailedTextLabel.isHidden = false
        case let .textCell(mainText, _):
            mainTextLabel.text = mainText
            mainTextLabel.textAlignment = .center
            
            detailedTextLabel.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: STSettingsCellViewModel? {
        didSet {
            setupUI()
        }
    }
    
    private let mainTextLabel = UILabel()
    private let detailedTextLabel = UILabel()
    
    static let reuseIdentifier = "STSettingCell"
}

private struct STLayout {
    
    let mainTextFrame: CGRect
    let detailedTextFrame: CGRect?
    
    static let cornerRadius: CGFloat = 16
    
    private static let labelHeight: CGFloat = 16
    
    static func build(in frame: CGRect, with model: STSettingsCellViewModel) -> STLayout {
        switch model {
        case .detailedCell(_, _, _):
            let mainTextFrame = CGRect(
                x: 12,
                y: frame.midY - labelHeight / 2,
                width: 192,
                height: labelHeight
            )
            let detailedTextFrame = CGRect(
                x: frame.maxX - 12 - 64,
                y: frame.midY - labelHeight / 2,
                width: 64,
                height: labelHeight
            )
            return STLayout(mainTextFrame: mainTextFrame, detailedTextFrame: detailedTextFrame)
        case .textCell(_, _):
            let mainTextFrame = CGRect(
                x: 16,
                y: frame.midY - labelHeight / 2,
                width: frame.width - 32,
                height: labelHeight
            )
            return STLayout(mainTextFrame: mainTextFrame, detailedTextFrame: nil)
        }
    }
}
