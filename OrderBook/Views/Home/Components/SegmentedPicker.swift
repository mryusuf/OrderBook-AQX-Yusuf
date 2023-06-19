//
//  SegmentedPicker.swift
//  OrderBook
//
//  Created by Indra Permana on 18/06/23.
//

import SwiftUI

struct SegementedPicker: View {

    @Binding var selected: String
    let options: [String]
    @Namespace var underline

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 30) {
                ForEach(options, id: \.self) { option in
                    VStack {
                        Button {
                            withAnimation {
                                selected = option
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(option)
                                    .font(selected == option ? .footnote.bold() : .footnote)
                                    .foregroundColor(selected == option ? .black : .gray)
                            }
                        }

                        ZStack {
                            Rectangle().fill(Color.gray)
                                .frame(height: 1)
                                .opacity(0)

                            if selected == option {
                                Rectangle().fill(Color.teal)
                                    .frame(height: 1)
                                    .matchedGeometryEffect(id: "option", in: underline)
                                    .padding(.horizontal, 12)
                            }
                        }

                    }
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.teal.opacity(0.2))
                .offset(y: -9)
        }
    }

}

