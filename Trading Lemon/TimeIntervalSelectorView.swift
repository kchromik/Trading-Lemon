//
//  TimeIntervalSelectorView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 03.06.22.
//

import SwiftUI

/// Select the time period for stock chart
struct TimeIntervalSelectorView: View {

    // @ObservedObject var manager: StocksDataManager

    // MARK: - Main rendering function
    var body: some View {
        HStack {
            ForEach(TimeSpan.allCases, content: { item in
                Button(action: {
                    manager.timeInterval = item
                    if let stock = manager.selectedStock?.symbol {
                        manager.fetchStockData(symbol: stock)
                    }
                }, label: {
                    Text(item.rawValue).bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(manager.timeInterval == item ? .white : .gray)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(manager.timeInterval == item ? .black : .white).padding(5))
                })
            })
        }
        .frame(height: 50)
        .background(RoundedRectangle(cornerRadius: 15))
        .padding([.leading, .trailing, .top]).padding(.bottom, 10).foregroundColor(.white)
    }
}
