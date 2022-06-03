//
//  TradeContentView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

/// Main view to buy/sell a stock
struct TradeContentView: View {

    @StateObject var tradingManager: TradingManager
    @Environment(\.dismiss) var dismiss
    @State private var sharesCount: Int = 1
    @State private var didPurchase: Bool = false
    let instrument: Instrument
    let lastPrice: Float
    @State private var showingAlert = false
    @State private var orderId: String = ""

    // MARK: - Main rendering function
    var body: some View {
        return VStack {
            Spacer()
            ZStack {
                if didPurchase {
                    confirmationView
                } else {
                    VStack(spacing: 0) {
                        Text("\(sharesCount)").font(.system(size: 40)).bold()
                        Text("How many shares of \(instrument.title) would you like?").foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                        Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).frame(width: UIScreen.main.bounds.width-60, height: 1).padding([.leading, .trailing]).padding()
                        Text("Your total cost will be").padding(.top, 10)
                        Text(Float(Float(sharesCount) * lastPrice).formattedAmount(with: instrument.venues[0].currency)).font(.system(size: 35)).bold()
                    }.lineLimit(1).minimumScaleFactor(0.5)
                    if Double(Float(sharesCount) * lastPrice) > 100000 {
                        VStack(spacing: 5) {
                            Spacer()
                            Text("Available: \(1000)")
                                .font(.system(size: 15)).foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                            HStack {
                                Image(systemName: "info.circle.fill")
                                Text("You don't have enough funds")
                            }.foregroundColor(.red).font(.system(size: 15)).padding(.bottom, 8)
                        }
                    }
                }
            }.frame(height: UIScreen.main.bounds.height/2.75)
            Spacer()
            ZStack {
                LinearGradient(gradient: Gradient(colors: [AppConfig.darkBackground]), startPoint: .top, endPoint: .bottom)
                    .mask(RoundedCorner(radius: 45, corners: [.topLeft, .topRight]))
                    .shadow(color: Color(#colorLiteral(red: 0.8827491403, green: 0.9036039114, blue: 0.9225834608, alpha: 1)), radius: 10, x: 0, y: -10)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    CustomNumberInputView(amount: $sharesCount)
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                guard let date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) else { return }
                                orderId = try await tradingManager.placeOrder(instrument: instrument, quantity: sharesCount,type: .buy, date: date)
                                if !orderId.isEmpty {
                                    showingAlert = true
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        Text("Place Order").font(.system(size: 20)).fontWeight(.medium)
                            .padding().padding([.leading, .trailing], 35).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(AppConfig.tradeButtonColor))
                    }).disabled(!isTransactionValid).opacity(isTransactionValid ? 1 : 0.5)
                }.padding(20)
            }
            .alert("Do you want to activate the order?", isPresented: $showingAlert) {
                Button("Yes") {
                    Task {
                        didPurchase = try await tradingManager.activateOrder(with: orderId)
                    }
                }
                Button("Later", role: .cancel) {
                    dismiss()
                }
            }
        }
    }

    /// Determine if the transaction details are filled out
    private var isTransactionValid: Bool {
        if lastPrice == 0.0 { return false }
        return sharesCount > 0 && Float(Float(sharesCount) * lastPrice) < 100000 && Float(Float(sharesCount) * lastPrice) > 50.0
    }

    /// Did purchase confirmation view
    private var confirmationView: some View {
        DispatchQueue.main.async { self.sharesCount = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dismiss()
        }
        return VStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill").font(.system(size: 60))
            Text("Order Placed").font(.title2)
        }.foregroundColor(AppConfig.tradeButtonColor)
    }
}
