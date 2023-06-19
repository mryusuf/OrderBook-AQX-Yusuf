//
//  OrderbookViewModel.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import SwiftUI

@MainActor protocol OrderBookViewModel: ObservableObject {
    var orderRows: [OrderBookRowViewModel] { get }
    var showingAlert: Bool { get }
    var errorMessage: String { get }
    
    func fetchOrderBooks() async
}

@MainActor final class OrderBookDefaultViewModel: OrderBookViewModel {
    
    @Published internal var orderRows: [OrderBookRowViewModel] = []
    @Published internal var showingAlert = false
    @Published internal var errorMessage = ""
    
    private let showingOrdersCount = 20
    private let stream: WebSocketRepository
    
    init(stream: WebSocketRepository) {
        self.stream = stream
    }
    
    func fetchOrderBooks() async {
        do {
            for try await message in stream {
                let updateOrder = try message.toOrderBook()
                switch updateOrder.action {
                    
                case .partial:
                    var buyOrders: [OrderBookData] = []
                    var sellOrders: [OrderBookData] = []
                    updateOrder.data?.forEach { (order: OrderBookData) in
                        if order.side == .buy {
                            let insertionIndex = buyOrders.insertionIndexOf(order) { $0.price ?? 0 > $1.price ?? 0 }
                            buyOrders.insert(order, at: insertionIndex)
                            if buyOrders.count > showingOrdersCount {
                                buyOrders.removeLast()
                            }
                        } else if order.side == .sell {
                            let insertionIndex = sellOrders.insertionIndexOf(order) { $0.price ?? 0 < $1.price ?? 0 }
                            sellOrders.insert(order, at: insertionIndex)
                            if sellOrders.count > showingOrdersCount {
                                sellOrders.removeLast()
                            }
                        }
                    }
                    var rows: [OrderBookRowViewModel] = []
                    for i in 0..<showingOrdersCount {
                        // safely get buyOrders and sellOrders at i and make new OrderBookRowViewModel
                        let row = OrderBookRowViewModel(buy: buyOrders[safe: i], sell: sellOrders[safe: i])
                        rows.append(row)
                    }
                    orderRows = rows
                case .insert:
                    updateOrder.data?.forEach { (order: OrderBookData) in
                        if order.side == .buy {
                            let insertionIndex = orderRows.insertionIndexOf(order, forSide: .buy) { $0?.price ?? 0 > $1?.price ?? 0 }
                            orderRows[insertionIndex >= orderRows.count ? orderRows.count - 1 : insertionIndex].buy = order
                        } else {
                            let insertionIndex = orderRows.insertionIndexOf(order, forSide: .sell) { $0?.price ?? 0 < $1?.price ?? 0 }
                            orderRows[insertionIndex >= orderRows.count ? orderRows.count - 1 : insertionIndex].sell = order
                        }
                    }
                case .update:
                    updateOrder.data?.forEach { (order: OrderBookData) in
                        if order.side == .buy {
                            if let row = orderRows.firstIndex(where: {$0.buy?.id == order.id}) {
                                orderRows[row].buy = order
                            }
                        } else {
                            if let row = orderRows.firstIndex(where: {$0.sell?.id == order.id}) {
                                orderRows[row].buy = order
                            }
                        }
                    }
                case .delete:
                    //                            updateOrder.data?.forEach { (order: OrderBookData) in
                    //                                if order.side == .buy {
                    //                                    orderRows = orderRows.filter { $0.buy?.id != order.id }
                    //                                } else {
                    //                                    orderRows = orderRows.filter { $0.sell?.id != order.id }
                    //                                }
                    //                            }
                    debugPrint("ignoring delete for now")
                case .none:
                    break
                }
            }
        } catch (let error) {
            
            debugPrint("Error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
