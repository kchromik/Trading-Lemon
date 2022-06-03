//
//  Position.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation

// MARK: - Result
struct Position: Codable {
    let isin, isinTitle: String
    let quantity, buyPriceAvg, estimatedPriceTotal, estimatedPrice: Int

    enum CodingKeys: String, CodingKey {
        case isin
        case isinTitle = "isin_title"
        case quantity
        case buyPriceAvg = "buy_price_avg"
        case estimatedPriceTotal = "estimated_price_total"
        case estimatedPrice = "estimated_price"
    }

    var isStockUp: Bool {
        estimatedPrice > buyPriceAvg
    }

    var formattedPerformance: String {
        let amount = (Float(estimatedPriceTotal - quantity * buyPriceAvg) / 10000.0).formattedAmount(with: "EUR")
        let percentage = (Float(estimatedPrice) / Float(buyPriceAvg)) - 1

        return "\(amount) \(String(format: "%.3f", percentage)) %"
    }
}
