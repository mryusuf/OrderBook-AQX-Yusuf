//
//  OrderBookRow.swift
//  OrderBook
//
//  Created by Indra Permana on 17/06/23.
//

import SwiftUI

struct OrderBookRow: View {
    
    let orderRow: OrderBookRowViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(NumberFormatter.sizeFormatter.string(for: orderRow.buy?.size) ?? "")
                    .font(.monospacedDigit(.footnote)())
                
                Spacer()
                
                Text(NumberFormatter.priceFormatter.string(for: orderRow.buy?.price) ?? "")
                    .font(.monospacedDigit(.body)())
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(
                        alignment: .trailing) {
                            Color
                                .green.opacity(0.2)
                                .frame(
                                    width: CGFloat((orderRow.buy?.size ?? 0)) / 1000
                                )
                        }
                    .foregroundColor(Color.green)
                
            }
            
            HStack {
                Text(NumberFormatter.priceFormatter.string(for: orderRow.sell?.price) ?? "")
                    .font(.monospacedDigit(.body)())
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        alignment: .leading) {
                            Color
                                .red.opacity(0.2)
                                .frame(
                                    width: CGFloat((orderRow.sell?.size ?? 0)) / 1000)
                        }
                    .foregroundColor(Color.red)
                
                Spacer()
                
                Text(NumberFormatter.sizeFormatter.string(for: orderRow.sell?.size) ?? "")
                    .font(.monospacedDigit(.footnote)())
                
            }
        }
    }
}

struct OrderBookRow_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let buyData = OrderBookData(symbol: "XBTUSD", id: 0, side: .buy, size: 5800, price: 25000, timestamp: Date.now.ISO8601Format())
        let sellData = OrderBookData(symbol: "XBTUSD", id: 0, side: .sell, size: 10000, price: 24000, timestamp: Date.now.ISO8601Format())
        let orderRow = OrderBookRowViewModel(buy: buyData, sell: sellData)
        
        OrderBookRow(orderRow: orderRow)
    }
}
