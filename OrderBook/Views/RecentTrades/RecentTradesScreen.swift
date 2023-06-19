//
//  RecentTradesScreen.swift
//  OrderBook
//
//  Created by Indra Permana on 17/06/23.
//

import SwiftUI

struct RecentTradesScreen: View {
    
    @ObservedObject private var viewModel = RecentTradesDefaultViewModel(stream: WebSocketRepository(url: Endpoints.recentTrades.url)
    )
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                Text("Recent Trades")
                    .foregroundColor(.gray)
                    .font(.footnote.bold())
                    .padding([.horizontal, .top], 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack(alignment: .center) {
                Text("Price (USD)")
                
                Spacer()
                
                Text("Size")
                
                Spacer()
                
                Text("Time")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.horizontal, 12)
            
            Divider()
            
            switch viewModel.state {
            case .idle:
                Color.clear
            case .loading:
                Color.clear
                    .frame(height: 100)
                ProgressView()
            case .failed(let error):
                Color.clear
                    .frame(height: 100)
                
                VStack {
                    Text("Error")
                        .foregroundColor(Color.red)
                    Text(error.localizedDescription)
                        .font(.footnote)
                }
                .padding()
            case .loaded(let recentTrades):
                LazyVStack() {
                    ForEach(recentTrades) { (trade: RecentTradeData) in
                        RecentTradeRow(trade: trade)
                            .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, -4)
            }
        }
        .task {
            await viewModel.fetchRecentTrades()
        }
    }
}

struct RecentTradesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecentTradesScreen()
    }
}
