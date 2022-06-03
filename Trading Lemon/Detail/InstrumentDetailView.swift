//
//  StockDetailView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct InstrumentDetailView: View {

    @StateObject private var tradingManager: TradingManager
    @Environment(\.dismiss) var dismiss
    @State private var instrument: Instrument?
    private var isin: String?
    @State private var showTradeView: Bool = false
    @State private var showSellAllAlert: Bool = false
    @State private var timeSpan = 1
    @State private var prices: [Double] = [1.0, 1.0, 1.0, 1.0]

    init(tradingManager: TradingManager, instrument: Instrument? = nil, isin: String? = nil) {
        _tradingManager = StateObject(wrappedValue: tradingManager)
        _instrument = State(initialValue: instrument)
        self.isin = isin
    }

    var body: some View {
        if let instrument = instrument {
            VStack {
                VStack {
                    Picker("Duration", selection: $timeSpan) {
                        Text("Day").tag(0)
                        Text("Month").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: timeSpan, perform: { newValue in
                        Task {
                            prices = try await tradingManager.fetchPrices(for: instrument.isin, timeSpan: timeSpan == 0 ? .day : .month)
                        }
                    })
                    if prices.isEmpty {
                        Text("no historic data available")
                            .italic()
                            .foregroundColor(AppConfig.lightText)
                            .frame(height: 120)
                    } else {
                        ChartView(chartHeight: 120, data: prices)
                    }
                }
                .padding([.leading, .trailing])

                List {
                    TitleDetailView(title: "ISIN", detail: instrument.isin)
                    TitleDetailView(title: "Type", detail: instrument.type.capitalized)

                    if !tradingManager.quotes.isEmpty {
                        TitleDetailView(title: "Sell Price", detail: "\(tradingManager.quotes[0].bitPrice.formattedAmount(with: instrument.venues[0].currency))")

                        TitleDetailView(title: "Buy Price", detail: " \(tradingManager.quotes[0].askPrice.formattedAmount(with: instrument.venues[0].currency))")

                        if hasPositions {
                            TitleDetailView(title: "Count", detail: "\(tradingManager.positions.filter { $0.isin == instrument.isin }.first?.quantity ?? 0)")
                        }
                    }
                }
                .listStyle(.inset)
                TradingButtons
            }
            .onAppear {
                Task {
                    try await tradingManager.latestQuotes(for: instrument.isin)
                    prices = try await tradingManager.fetchPrices(for: instrument.isin, timeSpan: .month)
                }
            }
            .sheet(isPresented: $showTradeView, content: {
                TradeContentView(tradingManager: tradingManager, instrument: instrument, lastPrice: tradingManager.quotes[0].askPrice)
            })
            .alert(isPresented: $showSellAllAlert, content: {
                Alert(title: Text("Sell all \(instrument.title) shares?"), message: Text("Are you sure you want to sell all your shares?"), primaryButton: .default(Text("Sell All"), action: {
                    Task {
                        guard let date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) else { return }
                        let id = try await tradingManager.placeOrder(instrument: instrument, quantity: tradingManager.positions.filter { $0.isin == instrument.isin }.first?.quantity ?? 0, type: .sell, date: date)
                        if try await tradingManager.activateOrder(with: id) {
                            try await tradingManager.fetchPositions()
                            dismiss()
                        }
                    }
                }), secondaryButton: .cancel())
            })
            .background(AppConfig.darkBackground)
            .navigationTitle(instrument.title)
        } else {
            ZStack {
                AppConfig.darkBackground
                    .ignoresSafeArea()
                ProgressView("Loading Instrument")
            }
                .onAppear {
                    Task {
                        if let isin = isin {
                            instrument = try await tradingManager.instrument(for: isin)
                        }
                    }
                }
        }
    }

    private var TradingButtons: some View {
        if let instrument = instrument {
            return AnyView(ZStack {
                VStack {
                    Spacer()
                    Color.white.ignoresSafeArea().frame(height: 82)
                }
                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                    HStack(spacing: 20) {
                        createTradeButton(title: "Buy", action: {
                            TradeContentView(tradingManager: tradingManager, instrument: instrument, lastPrice: tradingManager.quotes[0].askPrice)
                            showTradeView = true
                        })
                        createTradeButton(title: "Sell All", action: {
                            showSellAllAlert = true
                        }).disabled(!hasPositions).opacity(!hasPositions ? 0.5 : 1.0)
                    }
                    .padding()
                    .background(AppConfig.darkBackground)
                }
            })
        } else {
            return AnyView(EmptyView())
        }
    }

    /// Helper function to create a buy/sell button
    private func createTradeButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30).foregroundColor(.green)
                Text(title).foregroundColor(.white).bold()
            }
        }).frame(height: 50)
    }

    private var hasPositions: Bool {
        guard let instrument = instrument,
              let quantity  = tradingManager.positions.filter({ $0.isin == instrument.isin }).first?.quantity else {
            return false
        }
        return quantity > 0
    }
}

struct InstrumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentDetailView(tradingManager: TradingManager(), instrument: Instrument(isin: "US90184L1026", wkn: "A1W6XZ", name: "TWITTER INC. DL-,000005", title: "TWITTER INC.", symbol: "TWR", type: "stock", venues: []))
    }
}
