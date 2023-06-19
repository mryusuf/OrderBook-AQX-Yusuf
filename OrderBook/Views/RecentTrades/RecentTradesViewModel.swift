//
//  RecentTradesViewModel.swift
//  OrderBook
//
//  Created by Indra Permana on 19/06/23.
//

import SwiftUI

@MainActor protocol RecentTradesViewModel: ObservableObject {
    var state: ScreenState<[RecentTradeData]> { get }
    
    func fetchRecentTrades() async
}

@MainActor final class RecentTradesDefaultViewModel: RecentTradesViewModel {
    
    @Published private(set) var state: ScreenState<[RecentTradeData]> = .idle
    
    var recentTrades: [RecentTradeData] = []
    
    private let showingTradesCount = 30
    private let stream: WebSocketRepository
    
    init(stream: WebSocketRepository) {
        self.stream = stream
    }
    
    func fetchRecentTrades() async {
        state = .loading
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
                    state = .loaded(recentTrades)
                case .update:
                    updateTrade.data?.forEach { (trade: RecentTradeData) in
                        if let row = recentTrades.firstIndex(where: {$0.id == trade.id}) {
                            recentTrades[row] = trade
                        }
                    }
                    state = .loaded(recentTrades)
                case .delete:
                    debugPrint("ignoring delete for now")
                case .none:
                    break
                }
                
            }
        } catch (let error) {
            debugPrint("Error: \(error.localizedDescription)")
            state = .failed(error)
        }
    }
}
