//
//  STApp.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 09/03/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import UIKit
import Toast_Swift

import CoreML
import Vision

private let GOOGLE_API_KEY = "AIzaSyCC0Euft9AJ1NDdIct62HMd-sX4vk1qMI0"

private func mlToMatrix(_ arr: MLMultiArray) -> [[Double]] {
    return []
}

final class STApp {
    
    private init() {
        self.window = UIWindow()
        self.router = STRouter(window: self.window)
        ToastManager.shared.isTapToDismissEnabled = true
        STGoogleTranslator.shared.start(with: GOOGLE_API_KEY)
        
        do {
            let model = keras_ocr()
            
            let input = keras_ocrInput(input1: (UIImage(named: "ML_TEST")?.preparedInput()!)!)
            let options = MLPredictionOptions()
            options.usesCPUOnly = true
            let prediction = try model.prediction(input: input, options: options)
            
            func predToString(_ arr: MLMultiArray) -> String {
                let LETTERS = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", ""]
                var result = ""
                let stripe = 128
                for k in 2..<stripe {
                    var currentMax = Double(0)
                    var index = 0
                    for i in (k * LETTERS.count)..<(k*LETTERS.count + LETTERS.count) {
                        if arr[i].doubleValue > currentMax {
                            index = i
                            currentMax = arr[i].doubleValue
                        }
                    }
                    if currentMax > 0.1 {
                        result += LETTERS[index % LETTERS.count]
                        //print(LETTERS[index % LETTERS.count], "probabilty: \(currentMax)")
                    }
                }
                return result
            }
            
            print(predToString(prediction.output1))
            
        } catch {
            print("ERROR BLIN")
            return
        }
    }
    
    var routing: STRouting {
        return router
    }
    
    var database: STDatabase {
        return context.database
    }
    
    private let context = STAppContext()
    private let router: STRouter
    let window: UIWindow
    
    static let shared = STApp()
}
