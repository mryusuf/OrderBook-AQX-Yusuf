//
//  RecentTradesViewModel.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import SwiftUI

@MainActor protocol RecentTradesViewModel: ObservableObject {
    var recentTrades: [RecentTradeData] { get }
    var showingAlert: Bool { get }
    var errorMessage: String { get }
    
    func fetchRecentTrades() async
}

@MainActor final class RecentTradesDefaultViewModel: RecentTradesViewModel {
    
    @Published internal var recentTrades: [RecentTradeData] = []
    @Published internal var showingAlert = false
    @Published internal var errorMessage = ""
    
    private let showingTradesCount = 30
    private let stream: WebSocketRepository
    
    init(stream: WebSocketRepository) {
        self.stream = stream
    }
    
    func fetchRecentTrades() async {
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
