//
//  OrderBookRowViewModel.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import Foundation

struct OrderBookRowViewModel: Identifiable {
    let id = UUID()
    var buy: OrderBookData?
    var sell: OrderBookData?
}
