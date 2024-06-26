//
//  HomeScreen.swift
//  OrderBook
//
//  Created by Indra Permana on 18/06/23.
//

import SwiftUI

struct HomeScreen: View {
    @State var selectedTab = "Order Book"
    var tabs = ["Chart", "Order Book", "Recent Trades"]

    var body: some View {
        NavigationView {
            VStack {
                SegementedPicker(selected: $selectedTab, options: tabs)
                
                if selectedTab == tabs[0] {
                    Text("Charts")
                    Spacer()
                } else if selectedTab == tabs[1] {
                    OrderBookScreen()
                        .padding(.top, -16)
                } else {
                    RecentTradesScreen()
                        .padding(.top, -16)
                }
            }
            .navigationTitle(selectedTab)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
