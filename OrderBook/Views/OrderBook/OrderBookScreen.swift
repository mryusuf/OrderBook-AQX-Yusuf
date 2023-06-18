//
//  ContentView.swift
//  OrderBook
//
//  Created by Indra Permana on 13/06/23.
//

import SwiftUI

struct OrderBookScreen: View {
    
    @State private var orderRows: [OrderBookRowViewModel] = []
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    private let stream = WebSocketRepository(url: Endpoints.orderBook.url)
    private let showingOrdersCount = 20
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Size")
                
                Spacer()
                
                Text("Price (USD)")
                
                Spacer()
                
                Text("Size")
            }
            .padding(.horizontal, 12)
            
            Divider()
            
            LazyVStack() {
                ForEach(orderRows) { (orderRow: OrderBookRowViewModel) in
                    OrderBookRow(orderRow: orderRow)
                }
                .padding(.vertical, -4)
            }
            .padding(.horizontal, 12)
            .padding(.top, -4)
        }
        .task {
            do {
                // TODO: move this to Separate Object, like Interactor
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
    }
    
}

enum WebSocketError: Error {
    case invalidFormat
}

extension URLSessionWebSocketTask.Message {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookScreen()
    }
}
