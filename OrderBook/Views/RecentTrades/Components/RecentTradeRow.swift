//
//  RecentTradeRow.swift
//  OrderBook
//
//  Created by Indra Permana on 18/06/23.
//

import SwiftUI

struct RecentTradeRow: View {
    let trade: RecentTradeData
    
    @State private var colorOpacity = 0.25
    
    var body: some View {
        HStack {
            Text(NumberFormatter.priceFormatter.string(for: trade.price) ?? "")
                .font(.monospacedDigit(.body)())
                .fontWeight(.bold)
            
            Spacer()
            
            Text(NumberFormatter.sizeFormatter.string(for: trade.size) ?? "")
                .font(.monospacedDigit(.footnote)())
            
            Spacer()
            
            Text(DateFormatter.convertISODateTimeMilliSecDateFormat(from: trade.timestamp))
                .font(.monospacedDigit(.footnote)())
        }
        .foregroundColor(Color.white)
        .colorMultiply(trade.side == .buy ? Color.green.opacity(colorOpacity) : Color.red.opacity(colorOpacity))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.colorOpacity = 1
            }
        }
    }
}

struct RecentTradeRow_Previews: PreviewProvider {
    static var previews: some View {
        let buyData = RecentTradeData(timestamp: .now, symbol: "XBTUSD", side: .buy, size: 10000, price: 25000, tickDirection: "ZeroPlusTick", trdMatchID: "14a8462f-7b02-60cd-9a96-0a57ce2cf4c6", grossValue: nil, homeNotional: nil, foreignNotional: nil, trdType: nil)
        RecentTradeRow(trade: buyData)
    }
}
