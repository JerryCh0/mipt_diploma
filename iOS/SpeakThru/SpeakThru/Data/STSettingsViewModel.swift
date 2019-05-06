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
                detailedText: string(from: STApp.shared.database.getRecognizerType()),
                action: { STApp.shared.routing.open(screen: .recognitionModel) }
            ),
            STSettingsCellViewModel.detailedCell(
                mainText: "Целевой язык",
                detailedText: lang(from: STApp.shared.database.getTargetLang()),
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
    
    static func buildLanguageSettings() -> [STSettingsCellViewModel] {
        let callback: (_: String) -> Void = { lang in
            Analytics.logEvent("set_target_lang", parameters: ["lang" : lang])
            STApp.shared.database.set(targetLang: lang)
            STApp.shared.window.makeToast(
                "Язык установлен",
                duration: 2.0,
                position: .center,
                title: nil,
                image: nil,
                style: STStyleKit.toastStyle,
                completion: nil
            )
        }
        
        var result = [STSettingsCellViewModel]()
        
        for code in allCodes() {
            result.append(
                STSettingsCellViewModel.textCell(
                    mainText: lang(from: code),
                    action: {
                        callback(code)
                    }
                )
            )
        }
        
        return result
    }
    
    static func buildRecognizerSettings() -> [STSettingsCellViewModel] {
        let callback: (_: RecognizerType) -> Void = { type in
            Analytics.logEvent("set_recognizer_type", parameters: ["type" : type])
            STApp.shared.database.set(recognizerType: type)
            STApp.shared.window.makeToast(
                "Тип изменен",
                duration: 2.0,
                position: .center,
                title: nil,
                image: nil,
                style: STStyleKit.toastStyle,
                completion: nil
            )
        }
        
        var result = [STSettingsCellViewModel]()
        
        for type in allRecognizers() {
            result.append(
                STSettingsCellViewModel.textCell(
                    mainText: string(from: type),
                    action: {
                        callback(type)
                    }
                )
            )
        }
        
        return result
    }
    
}
