//
//  STDatabase.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

protocol STDatabase {
    
    func isApplicationRunsFirstTime() -> Bool
    
    func forceDump()
    
    func add(listener: STDatabaseListener)
    func remove(listener: STDatabaseListener)
    
    func getAllTranslations() -> [String : STTranslation]
    func removeAllTranslations() -> Bool
    func getTranslation(with id: String) -> STTranslation?
    func store(translation: STTranslation) -> Bool
    func removeTranslation(with id: String) -> Bool
    
    func set(targetLang: String) -> Bool
    func getTargetLang() -> String
    
    func set(recognizerType: RecognizerType) -> Bool
    func getRecognizerType() -> RecognizerType
}

protocol STDatabaseListener {
    func onDataUpdated()
    func id() -> String
}

final class STDatabaseImpl: STDatabase {
    
    init() {
        let decoded = standardDefaults.data(forKey: dictKey)
        if decoded == nil {
            translationsMap = [:]
            return
        } else {
            let decodedMap = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? [String : STTranslation]
            translationsMap = decodedMap ?? [:]
        }
    }
    
    deinit {
        dump()
    }
    
    func forceDump() {
        dump()
    }
    
    func add(listener: STDatabaseListener) {
        listeners.append(listener)
    }
    
    func remove(listener: STDatabaseListener) {
        listeners = listeners.filter { return $0.id() != listener.id() }
    }
    
    func getAllTranslations() -> [String : STTranslation] {
        return translationsMap
    }
    
    func getTranslation(with id: String) -> STTranslation? {
        guard id != STTranslation.nullId, translationsMap.keys.contains(id) else { return nil }
        return translationsMap[id]
    }
    
    func store(translation: STTranslation) -> Bool {
        guard translation.id != STTranslation.nullId else { return false }
        translationsMap[translation.id] = translation
        notifyListeners()
        return true
    }
    
    func removeTranslation(with id: String) -> Bool {
        guard id != STTranslation.nullId, translationsMap.keys.contains(id) else { return false }
        translationsMap.removeValue(forKey: id)
        notifyListeners()
        return true
    }
    
    func removeAllTranslations() -> Bool {
        translationsMap.removeAll()
        notifyListeners()
        return true
    }
    
    func isApplicationRunsFirstTime() -> Bool {
        let value = standardDefaults.value(forKey: firstLaunchKey) as? Bool
        return value ?? true
    }
    
    func set(targetLang: String) -> Bool {
        targetLanguage = targetLang
        notifyListeners()
        return true
    }
    
    func getTargetLang() -> String {
        return targetLanguage
    }
    
    func set(recognizerType: RecognizerType) -> Bool {
        self.recognizerType = recognizerType
        notifyListeners()
        return true
    }
    
    func getRecognizerType() -> RecognizerType {
        return recognizerType
    }
    
    private func notifyListeners() {
        for listener in listeners {
            listener.onDataUpdated()
        }
    }
    
    private func dump() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: translationsMap)
        standardDefaults.set(encodedData, forKey: dictKey)
        standardDefaults.set(false, forKey: firstLaunchKey)
        standardDefaults.set(targetLanguage, forKey: targetLangKey)
        standardDefaults.set(string(from: recognizerType), forKey: recognizerTypeKey)
        standardDefaults.synchronize()
    }
    
    private var translationsMap: [String : STTranslation]
    
    private let standardDefaults = UserDefaults.standard
    
    private let dictKey = "translations_dictionary"
    private let firstLaunchKey = "application_runs_first_time"
    private let targetLangKey = "translation_target_language"
    private let recognizerTypeKey = "recognizer_type"
    
    private var listeners = [STDatabaseListener]()
    
    private lazy var targetLanguage: String = {
        return standardDefaults.value(forKey: targetLangKey) as! String
    }()
    private lazy var recognizerType: RecognizerType = {
        return type(from: standardDefaults.value(forKey: recognizerTypeKey) as! String)
    }()
}
