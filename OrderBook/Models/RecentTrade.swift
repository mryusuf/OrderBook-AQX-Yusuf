//
//  RecentTrade.swift
//  OrderBook
//
//  Created by Indra Permana on 18/06/23.
//

import Foundation

import Foundation

struct RecentTrade: Codable {
    let table: String?
    let action: OrderBookActions?
    let data: [RecentTradeData]?
}

struct RecentTradeData: Codable, Identifiable {
    
    let timestamp: Date
    let symbol: String?
    let side: OrderBookSide?
    let size: Int?
    let price: Double?
    let tickDirection, trdMatchID: String?
    let grossValue: Int?
    let homeNotional: Double?
    let foreignNotional: Int?
    let trdType: String?
    
    var id: String? {
        trdMatchID
    }
    
    enum CodingKeys: CodingKey {
        case timestamp
        case symbol
        case side
        case size
        case price
        case tickDirection
        case trdMatchID
        case grossValue
        case homeNotional
        case foreignNotional
        case trdType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        self.side = try container.decodeIfPresent(OrderBookSide.self, forKey: .side)
        self.size = try container.decodeIfPresent(Int.self, forKey: .size)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
        self.tickDirection = try container.decodeIfPresent(String.self, forKey: .tickDirection)
        self.trdMatchID = try container.decodeIfPresent(String.self, forKey: .trdMatchID)
        self.grossValue = try container.decodeIfPresent(Int.self, forKey: .grossValue)
        self.homeNotional = try container.decodeIfPresent(Double.self, forKey: .homeNotional)
        self.foreignNotional = try container.decodeIfPresent(Int.self, forKey: .foreignNotional)
        self.trdType = try container.decodeIfPresent(String.self, forKey: .trdType)
        
        let dateString = try container.decode(String.self, forKey: .timestamp)
        let formatter = DateFormatter.iso8601Full
        if let date = formatter.date(from: dateString) {
            timestamp = date
        } else {
            timestamp = Date.init()
        }
    }
    
    init(timestamp: Date, symbol: String?, side: OrderBookSide?, size: Int?, price: Double?, tickDirection: String?, trdMatchID: String?, grossValue: Int?, homeNotional: Double?, foreignNotional: Int?, trdType: String?) {
        self.timestamp = timestamp
        self.symbol = symbol
        self.side = side
        self.size = size
        self.price = price
        self.tickDirection = tickDirection
        self.trdMatchID = trdMatchID
        self.grossValue = grossValue
        self.homeNotional = homeNotional
        self.foreignNotional = foreignNotional
        self.trdType = trdType
    }
}
