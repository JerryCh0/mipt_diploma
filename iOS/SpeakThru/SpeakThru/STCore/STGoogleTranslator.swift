//
//  STGoogleTranslator.swift
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 02/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

import Foundation

public class STGoogleTranslator {

    public static let shared = STGoogleTranslator()

    public struct Language {
        public let language: String
        public let name: String
    }
    
    public struct Detection {
        public let language: String
        public let isReliable: Bool
        public let confidence: Float
    }
    
    private struct API {
        static let base = "https://translation.googleapis.com/language/translate/v2"
        
        struct translate {
            static let method = "POST"
            static let url = API.base
        }
    }
    
    private var apiKey: String!
    private let session = URLSession(configuration: .default)

    public func start(with apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func translate(_ q: String, _ target: String, _ source: String, _ format: String = "text", _ model: String = "base", _ completion: @escaping ((_ text: String?, _ error: Error?) -> Void)) {
        guard var urlComponents = URLComponents(string: API.translate.url) else {
            completion(nil, nil)
            return
        }
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "q", value: q))
        queryItems.append(URLQueryItem(name: "target", value: target))
        queryItems.append(URLQueryItem(name: "source", value: source))
        queryItems.append(URLQueryItem(name: "format", value: format))
        queryItems.append(URLQueryItem(name: "model", value: model))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.translate.method
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, error)
                    return
            }
            
            guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let translations = d["translations"] as? [[String: String]], let translation = translations.first, let translatedText = translation["translatedText"] else {
                completion(nil, error)
                return
            }
            
            completion(translatedText, nil)
        }
        task.resume()
    }
    
}
