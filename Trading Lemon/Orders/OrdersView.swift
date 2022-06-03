//
//  OrdersView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 01.06.22.
//

import SwiftUI

struct OrdersView: View {

    @StateObject var tradingManager: TradingManager
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                AppConfig.darkBackground
                    .ignoresSafeArea()
                contentView
                    .padding(8)
            }
            .background(AppConfig.darkBackground)
            .navigationTitle("Orders")
        }
        .onAppear {
            Task {
                try await tradingManager.fetchOrders()
            }
        }
    }

    private var contentView: some View {
        if tradingManager.orders.isEmpty {
            return AnyView(Text("No open orders")
                .foregroundColor(AppConfig.lightText))
        } else {
            return AnyView(ScrollView {
                ForEach(tradingManager.orders, id: \.id) { order in
                    OrderView(order: order)
                        .onTapGesture {
                            if order.status == "inactive" {
                                showingAlert = true
                            }
                        }
                        .alert("Do you want to activate the order?", isPresented: $showingAlert) {
                            Button("Yes") {
                                Task {
                                    if try await tradingManager.activateOrder(with: order.id) {
                                        try await tradingManager.fetchOrders()
                                    }
                                }
                            }
                            Button("Later", role: .cancel) { }
                        }
                }
            })
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(tradingManager: TradingManager())
    }
}
