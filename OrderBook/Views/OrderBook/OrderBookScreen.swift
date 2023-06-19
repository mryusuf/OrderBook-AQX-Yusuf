//
//  ContentView.swift
//  OrderBook
//
//  Created by Indra Permana on 13/06/23.
//

import SwiftUI

struct OrderBookScreen: View {

    @ObservedObject private var viewModel = OrderBookDefaultViewModel(
        stream: WebSocketRepository(url: Endpoints.orderBook.url)
    )
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Size")
                
                Spacer()
                
                Text("Price (USD)")
                
                Spacer()
                
                Text("Size")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding([.horizontal, .top], 12)
            
            Divider()
            
            switch viewModel.state {
            case .idle:
                Color.clear
            case .loading:
                Color.clear
                    .frame(height: 100)
                ProgressView()
            case .failed(let error):
                VStack {
                    Text("Error")
                        .foregroundColor(Color.red)
                    Text(error.localizedDescription)
                        .font(.footnote)
                }
                .padding()
            case .loaded(let orderRows):
                LazyVStack() {
                    ForEach(orderRows) { (orderRow: OrderBookRowViewModel) in
                        OrderBookRow(orderRow: orderRow)
                    }
                    .padding(.vertical, -4)
                }
                .padding(.horizontal, 12)
                .padding(.top, -4)
            }
        }
        .task {
            await viewModel.fetchOrderBooks()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookScreen()
    }
}
