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

final class STApp {
    
    private init() {
        self.window = UIWindow()
        self.router = STRouter(window: self.window)
        ToastManager.shared.isTapToDismissEnabled = true
        STGoogleTranslator.shared.start(with: GOOGLE_API_KEY)
        
        do {
            let model = apnr_ocr()
            
            
            let image = resizeImage(
                image: UIImage(named: "ML_TEST")!,
                targetSize: CGSize(width: 128, height: 64)
            )
            
            let input = apnr_ocrInput(input1: preprocess(image: image)!)
            let prediction = try model.prediction(input: input)
            
            func predToString(arr: MLMultiArray) -> String {
                let LETTERS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "E", "H", "K", "M", "O", "P", "T", "X", "Y", ""]
                var result = ""
                for k in 0..<32 {
                    var currentMax = Double(0)
                    var index = 0
                    for i in (k * 32)..<(k*32 + 23) {
                        if arr[i].doubleValue > currentMax {
                            index = i
                            currentMax = arr[i].doubleValue
                        }
                    }
                    if currentMax > 0.1 {
                        result += LETTERS[index % 32]
                        print(LETTERS[index % 32], "probabilty: \(currentMax)")
                    }
                }
                return result
            }
            
            print(predToString(arr: prediction.output1))
            
        } catch {
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
