//
//  OHLC.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 01.06.22.
//

import Foundation

struct OHLC: Codable {
    let isin: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Int
    let pricebyVolume: Double

    enum CodingKeys: String, CodingKey {
        case isin
        case open = "o"
        case high = "h"
        case low = "l"
        case close = "c"
        case volume = "v"
        case pricebyVolume = "pbv"
    }
}
