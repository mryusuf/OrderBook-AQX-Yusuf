//
//  APIConfig.swift
//  OrderBook
//
//  Created by Indra Permana on 15/06/23.
//

import Foundation

public struct APIConfig {
    enum Keys {
        static let baseURL = "BASE_URL"
    }
    
    static let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String else {
            return ""
        }
        return baseURLProperty
    }()
}
