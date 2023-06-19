//
//  ScreenState.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import Foundation

enum ScreenState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
