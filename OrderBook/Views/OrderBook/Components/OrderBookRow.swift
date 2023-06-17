//
//  OrderBookRow.swift
//  OrderBook
//
//  Created by Indra Permana on 17/06/23.
//

import SwiftUI

struct OrderBookRow: View {
    
    let orderRow: OrderBookRowViewModel
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }()
    private let sizeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var body: some View {
        HStack {
            HStack {
                Text(sizeFormatter.string(for: orderRow.buy?.size) ?? "")
                    .font(.monospacedDigit(.footnote)())
                
                Spacer()
                
                Text(priceFormatter.string(for: orderRow.buy?.price) ?? "")
                    .font(.monospacedDigit(.body)())
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(
                        alignment: .trailing) {
                            Color
                                .green.opacity(0.2)
                                .frame(
                                    maxWidth: CGFloat((orderRow.buy?.size ?? 0)) / 1000
                                )
                        }
                    .foregroundColor(Color.green)
                
            }
            
            HStack {
                Text(priceFormatter.string(for: orderRow.sell?.price) ?? "")
                    .font(.monospacedDigit(.body)())
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        alignment: .leading) {
                            Color
                                .red.opacity(0.2)
                                .frame(
                                    maxWidth: CGFloat((orderRow.sell?.size ?? 0)) / 1000)
                        }
                    .foregroundColor(Color.red)
                
                Spacer()
                
                Text(sizeFormatter.string(for: orderRow.sell?.size) ?? "")
                    .font(.monospacedDigit(.footnote)())
                
            }
        }
    }
}

struct OrderBookRow_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let buyData = OrderBookData(symbol: "XBTUSD", id: 0, side: .buy, size: 100, price: 25000, timestamp: "")
        let sellData = OrderBookData(symbol: "XBTUSD", id: 0, side: .sell, size: 100, price: 24000, timestamp: "")
        let orderRow = OrderBookRowViewModel(buy: buyData, sell: sellData)
        
        OrderBookRow(orderRow: orderRow)
    }
}
