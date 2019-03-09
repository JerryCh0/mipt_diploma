//
//  STRouting.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

enum STScreen {
    case main
    case settings
    case bookmarks
    case translation
    case about
}

protocol STRouting {
    func open(screen: STScreen)
}
