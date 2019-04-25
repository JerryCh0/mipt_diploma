//
//  STDatabase.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 25/04/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

protocol STDatabase {
    
    func forceDump()
    
    func add(listener: STDatabaseListener)
    func remove(listener: STDatabaseListener)
    
    func getAllTranslations() -> [String : STTranslation]
    func getTranslation(with id: String) -> STTranslation?
    func store(translation: STTranslation) -> Bool
    func removeTranslation(with id: String) -> Bool
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
    
    private func notifyListeners() {
        for listener in listeners {
            listener.onDataUpdated()
        }
    }
    
    private func dump() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: translationsMap)
        standardDefaults.set(encodedData, forKey: dictKey)
        standardDefaults.synchronize()
    }
    
    private var translationsMap: [String : STTranslation]
    private let standardDefaults = UserDefaults.standard
    
    private let dictKey = "translations_dictionary"
    
    private var listeners = [STDatabaseListener]()
    
}
