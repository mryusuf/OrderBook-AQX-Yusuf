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
            
            LazyVStack() {
                ForEach(viewModel.orderRows) { (orderRow: OrderBookRowViewModel) in
                    OrderBookRow(orderRow: orderRow)
                }
                .padding(.vertical, -4)
            }
            .padding(.horizontal, 12)
            .padding(.top, -4)
        }
        .task {
            await viewModel.fetchOrderBooks()
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBookScreen()
    }
}
