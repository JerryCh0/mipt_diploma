//
//  STStyleKit.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 31/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit

final class STStyleKit {
    
    static let backIcon = UIImage(named: "STButtonBack")!
    static let closeIcon = UIImage(named: "STButtonClose")!
    static let settingsIcon = UIImage(named: "STButtonSettings")!
    static let bookmarksIcon = UIImage(named: "STButtonBookmarks")!
    static let copyIcon = UIImage(named: "STButtonCopy")!
    static let saveIcon = UIImage(named: "STButtonSave")!
    static let savedIcon = UIImage(named: "STButtonSaved")!
    
    static let shutterImage = UIImage(named: "STButtonShutter")!
    static let arrowImage = UIImage(named: "STArrow")!
    
}

final class STColor : UIColor {
    
    static let neonBlue = STColor(hexString: "#21C1D4")
    static let greyBlue = STColor(hexString: "#142E49")
    
}

private extension STColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
