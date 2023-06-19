//
//  Message+Ext.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import Foundation

extension URLSessionWebSocketTask.Message {
    
    /// Map from `URLSessionWebSocketTask Message` to `OrderBook`
    func toOrderBook() throws -> OrderBook {
        switch self {
        case .string(let json):
            let decoder = JSONDecoder()
            guard let data = json.data(using: .utf8) else {
                throw WebSocketError.invalidFormat
            }
            
            let message = try decoder.decode(OrderBook.self, from: data)
            return message
        case .data:
            throw WebSocketError.invalidFormat
        @unknown default:
            throw WebSocketError.invalidFormat
        }
    }
    
    /// Map from `URLSessionWebSocketTask Message` to `RecentTrade`
    func toRecentTrade() throws -> RecentTrade {
        switch self {
        case .string(let json):
            let decoder = JSONDecoder()
            guard let data = json.data(using: .utf8) else {
                throw WebSocketError.invalidFormat
            }
            
            let message = try decoder.decode(RecentTrade.self, from: data)
            return message
        case .data:
            throw WebSocketError.invalidFormat
        @unknown default:
            throw WebSocketError.invalidFormat
        }
    }
}

enum WebSocketError: Error {
    case invalidFormat
}
