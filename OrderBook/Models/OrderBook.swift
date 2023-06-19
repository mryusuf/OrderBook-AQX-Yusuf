//
//  OrderBook.swift
//  OrderBook
//
//  Created by Indra Permana on 15/06/23.
//

import Foundation

struct OrderBook: Codable {
    let table: String?
    let action: OrderBookActions?
    let data: [OrderBookData]?
}

struct OrderBookData: Codable, Identifiable {
    let symbol: String?
    let id: Int?
    let side: OrderBookSide?
    let size: Int?
    let price: Double?
    let timestamp: String?
}

enum OrderBookActions: String, Codable {
    case partial = "partial"
    case insert = "insert"
    case update = "update"
    case delete = "delete"
}

enum OrderBookSide: String, Codable {
    case buy = "Buy"
    case sell = "Sell"
}
