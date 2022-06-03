//
//  TradingManager.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 30.03.22.
//

import Foundation

class TradingManager: ObservableObject {

    enum OrderType: String {
        case buy
        case sell
    }

    enum TimeSpan {
        case day
        case month
    }

    @Published var account: Account?
    @Published var positions: [Position] = []
    @Published var searchResults: [Instrument] = []
    @Published var quotes: [Quote] = []
    @Published var orders: [Order] = []

    func searchInstrument(with term: String) async throws {
        let urlString = (AppConfig.marketDataBaseURL + "instruments?search=\(term)&type=stock, etf").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)!
        let request = URLRequest(url: url).authenticated()

        let searchResults = try await NetworkAdapter().send(request: request, type: SearchResult.self).results
        DispatchQueue.main.async {
            self.searchResults = searchResults
        }
    }

    func instrument(for isin: String) async throws -> Instrument? {
        let url = URL(string: AppConfig.marketDataBaseURL + "instruments?isin=\(isin)")!
        let request = URLRequest(url: url).authenticated()

        return try await NetworkAdapter().send(request: request, type: SearchResult.self).results.first
    }

    func fetchAccount() async throws {
        let url = URL(string: AppConfig.tradingBaseURL + "account")!
        let request = URLRequest(url: url).authenticated()

        let account = try await NetworkAdapter().send(request: request, type: AccountResult.self).results
        DispatchQueue.main.async {
            self.account = account
        }
    }

    func fetchPositions() async throws {
        let url = URL(string: AppConfig.tradingBaseURL + "positions")!
        let request = URLRequest(url: url).authenticated()

        let positions = try await NetworkAdapter().send(request: request, type: PositionResult.self).results
        DispatchQueue.main.async {
            self.positions = positions
        }
    }

    func placeOrder(instrument: Instrument, quantity: Int, type: OrderType, date: Date) async throws -> String {
        let url = URL(string: AppConfig.tradingBaseURL + "orders")!
        let request = URLRequest(url: url)
            .authenticated()
            .withContentTypeHeader()
            .withHttp(method: .POST)
            .withHttp(body: ["isin": instrument.isin, "quantity": "\(quantity)", "expires_at": date.formatted, "side": type.rawValue, "venue": instrument.venues.first!.mic])

        return try await NetworkAdapter().send(request: request, type: OrderResult.self).results.id
    }

    func activateOrder(with id: String) async throws -> Bool {
        let url = URL(string: AppConfig.tradingBaseURL + "orders/\(id)/activate")!
        let request = URLRequest(url: url)
            .authenticated()
            .withHttp(method: .POST)

        let result = try await NetworkAdapter().send(request: request, type: OrderActivation.self).success
        return result
    }

    func latestQuotes(for isin: String) async throws {
        let url = URL(string: AppConfig.marketDataBaseURL + "quotes/latest/?isin=\(isin)")!
        let request = URLRequest(url: url)
            .authenticated()

        let quotes = try await NetworkAdapter().send(request: request, type: QuoteResult.self).results
        DispatchQueue.main.async {
            self.quotes = quotes
        }
    }

    func fetchOrders() async throws  {
        let url = URL(string: AppConfig.tradingBaseURL + "orders")!
        let request = URLRequest(url: url)
            .authenticated()
        let orders = try await NetworkAdapter().send(request: request, type: OrdersResult.self).results
        let inactiveOrders = orders.filter { $0.status == "inactive" }
        let allOtherOrders = orders.filter { $0.status != "inactive" }

        DispatchQueue.main.async {
            self.orders = inactiveOrders + allOtherOrders
        }
    }

    func fetchPrices(for isin: String, timeSpan: TimeSpan) async throws -> [Double] {
        var timeParam: String
        var dateParam: String
        switch timeSpan {
        case .day:
            timeParam = "h1"
            let now = Calendar.current.date(byAdding: .day, value: -1, to: .now)!.formatted
            dateParam = "from=\(now)"
        case .month:
            timeParam = "d1"
            let oneMonthAgo = Calendar.current.date(byAdding: .day, value: -30, to: .now)!.formatted
            dateParam = "from=\(oneMonthAgo)"

        }

        let url = URL(string: AppConfig.marketDataBaseURL + "ohlc/\(timeParam)?isin=\(isin)&\(dateParam)")!
        let request = URLRequest(url: url)
            .authenticated()

        let result = try await NetworkAdapter().send(request: request, type: OHLCResult.self).results.map { $0.close }
        return result
    }
}
