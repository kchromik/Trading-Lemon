//
//  OrdersSummaryView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct PositionsSummaryView: View {

    @StateObject var tradingManager: TradingManager

    var body: some View {
        ScrollView {
            ForEach(tradingManager.positions, id: \.isin) { position in
                NavigationLink {
                    InstrumentDetailView(tradingManager: tradingManager, isin: position.isin)
                } label: {
                    PositionView(position: position)
                }
            }
        }
    }
}

struct PositionsSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PositionsSummaryView(tradingManager: TradingManager())
    }
}
