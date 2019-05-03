//
//  STSettingsViewModel.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 02/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum STSettingsCellViewModel {
    case detailedCell(mainText: String, detailedText: String, action: () -> Void)
    case textCell(mainText: String, action: () -> Void)
}

final class STSettingsViewModelFactory {
    
    static func buildMainSettings() -> [STSettingsCellViewModel] {
        let result = [
            STSettingsCellViewModel.detailedCell(
                mainText: "Модель распознавания",
                detailedText: "Firebase",
                action: { STApp.shared.routing.open(screen: .recognitionModel) }
            ),
            STSettingsCellViewModel.detailedCell(
                mainText: "Целевой язык",
                detailedText: "Русский",
                action: { STApp.shared.routing.open(screen: .targetLanguage) }
            ),
            STSettingsCellViewModel.textCell(
                mainText: "Очистить сохраненные переводы",
                action: {
                    Analytics.logEvent("clear_translations", parameters: nil)
                    STApp.shared.database.removeAllTranslations()
                }
            )
        ] as [STSettingsCellViewModel]
        return result
    }
    
}
