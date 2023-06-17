//
//  Endpoints.swift
//  OrderBook
//
//  Created by Indra Permana on 15/06/23.
//

import Foundation

protocol Endpoint {
    
    var url: URL { get }
    var httpMethod: String { get }
    var headers: [String: String]? { get }
}

enum Endpoints: Endpoint {
    case orderBook
    case recentTrades
    
    var url: URL {
        switch self {
        case .orderBook:
            do {
                let url = try makeURL(fromURLString: "\(APIConfig.baseURL)/realtime?subscribe=orderBookL2:XBTUSD")
                return url
            } catch {
                fatalError(APIError.invalidURL.localizedDescription)
            }
        case .recentTrades:
            do {
                let url = try makeURL(fromURLString: "\(APIConfig.baseURL)/realtime?subscribe=trade:XBTUSD")
                return url
            } catch {
                fatalError(APIError.invalidURL.localizedDescription)
            }
        }
    }
    var httpMethod: String {
        return ""
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
}

extension Endpoints {
    func makeURL(fromURLString urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        return url
    }
}


enum APIError: Swift.Error {
    case invalidURL
    case httpCode(Int)
    case unexpectedResponse
    case imageDeserialization
}
