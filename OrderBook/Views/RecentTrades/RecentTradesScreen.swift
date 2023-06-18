//
//  RecentTradesScreen.swift
//  OrderBook
//
//  Created by Indra Permana on 17/06/23.
//

import SwiftUI

struct RecentTradesScreen: View {
    
    @State private var recentTrades: [RecentTradeData] = []
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    private let stream = WebSocketRepository(url: Endpoints.recentTrades.url)
    
    private let showingTradesCount = 30
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                HStack(alignment: .center) {
                    Text("Price (USD)")
                    
                    Spacer()
                    
                    Text("Size")
                    
                    Spacer()
                    
                    Text("Time")
                }
                .padding(.horizontal, 12)
                
                Divider()
                
                LazyVStack() {
                    ForEach(recentTrades) { (trade: RecentTradeData) in
                        RecentTradeRow(trade: trade)
                            .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, -4)
            }
            .task {
                do {
                    for try await message in stream {
                        let updateTrade = try message.toRecentTrade()
                        switch updateTrade.action {
                        case .partial, .insert:
                            updateTrade.data?.forEach { (trade: RecentTradeData) in
                                let insertionIndex = recentTrades.insertionIndexOf(trade) { $0.timestamp > $1.timestamp }
                                recentTrades.insert(trade, at: insertionIndex)
                                if recentTrades.count > showingTradesCount {
                                    recentTrades.removeLast()
                                }
                            }
                        case .update:
                            updateTrade.data?.forEach { (trade: RecentTradeData) in
                                if let row = recentTrades.firstIndex(where: {$0.id == trade.id}) {
                                    recentTrades[row] = trade
                                }
                            }
                        case .delete:
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
    }
}

extension URLSessionWebSocketTask.Message {
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

struct RecentTradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradesScreen()
    }
}
