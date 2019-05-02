//
//  STSettingsViewModel.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 02/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

enum STSettingsCellViewModel {
    case detailedCell(mainText: String, detailedText: String, action: () -> Void)
    case textCell(mainText: String, action: () -> Void)
}

final class STSettingsViewModelFactory {
    
    
    
}
