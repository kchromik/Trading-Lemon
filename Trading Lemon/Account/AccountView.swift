//
//  AccountView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct AccountView: View {

    @StateObject var tradingManager: TradingManager

    var body: some View {
        NavigationView {
            VStack {
                if let account = tradingManager.account {
                    accountView(account: account)
                        .background(AppConfig.darkBackground)
                }
            }
            .navigationTitle("Dashboard")
        }
        .onAppear {
            Task {
                try await tradingManager.fetchAccount()
            }
        }
    }

    private func accountView(account: Account) -> some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(account.firstname)
                    .foregroundColor(AppConfig.lightText)
                    .font(.system(size: 24)).bold()
                    .padding(.bottom, 8)

                HStack {
                    Text((Float(account.cashToInvest) / 10000).formattedAmount(with: "EUR"))
                        .foregroundColor(AppConfig.lightText)
                        .font(.system(size: 20)).bold()

                    Spacer()
                    HStack {
                        Image(systemName: isOverallUp ? "arrowtriangle.up.fill": "arrowtriangle.down.fill")
                        Text(overallPerformance)
                    }
                    .font(.system(size: 20))
                    .foregroundColor(isOverallUp ? AppConfig.tradeButtonColor : AppConfig.negativeColor)
                }
                .padding(.bottom, 8)


                Spacer()
                if !tradingManager.positions.isEmpty {
                    PositionsSummaryView(tradingManager: tradingManager)
                }
                Spacer()
            }
            .onAppear {
                Task {
                    try await tradingManager.fetchPositions()
                }
            }

        }
        .padding([.leading, .trailing], 8)
    }

    private var overallPerformance: String {
        let portfolioWorth = tradingManager.positions.map { $0.estimatedPriceTotal }.reduce(0, +)
        let portfolioSpendings = tradingManager.positions.map { $0.quantity * $0.buyPriceAvg }.reduce(0, +)

        let amount = (Float(portfolioWorth - portfolioSpendings) / 10000.0).formattedAmount(with: "EUR")
        let percentage = (Float(portfolioWorth) / Float(portfolioSpendings)) - 1

        
        return "\(amount) \(String(format: "%.3f", percentage)) %"
    }

    private var isOverallUp: Bool {
        let portfolioWorth = tradingManager.positions.map { $0.estimatedPriceTotal }.reduce(0, +)
        let portfolioSpendings = tradingManager.positions.map { $0.quantity * $0.buyPriceAvg }.reduce(0, +)

        return portfolioWorth > portfolioSpendings
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(tradingManager: TradingManager())
    }
}
