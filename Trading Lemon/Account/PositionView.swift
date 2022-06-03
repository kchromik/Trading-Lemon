//
//  PositionView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct PositionView: View {

    let position: Position

    var body: some View {
        HStack {
            Text(position.isinTitle).bold()
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundColor(AppConfig.lightText)
            Spacer()
            VStack(alignment: .trailing) {
                Text((Float(position.estimatedPriceTotal) / 10000).formattedAmount(with: "EUR"))
                    .foregroundColor(AppConfig.lightText)
                Spacer()
                HStack {
                    Image(systemName: position.isStockUp ? "arrowtriangle.up.fill": "arrowtriangle.down.fill")
                    Text(position.formattedPerformance)
                }
                .font(.system(size: 15))
                .foregroundColor(position.isStockUp ? AppConfig.tradeButtonColor : AppConfig.negativeColor)
            }
        }
        .padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(AppConfig.lightBackground))
    }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        PositionView(position: Position(isin: "dfsf", isinTitle: "", quantity: 3, buyPriceAvg: 100, estimatedPriceTotal: 100, estimatedPrice: 100))
    }
}
