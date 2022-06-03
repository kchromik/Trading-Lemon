//
//  WrapperModels.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation

struct SearchResult: Codable {
    let results: [Instrument]
}

struct AccountResult: Codable {
    let results: Account
}

struct OrderResult: Codable {
    let results: Order
}

struct OrdersResult: Codable {
    let results: [Order]
}

struct PositionResult: Codable {
    let results: [Position]
}

struct QuoteResult: Codable {
    let results: [Quote]
}

struct OHLCResult: Codable {
    let results: [OHLC]
}
