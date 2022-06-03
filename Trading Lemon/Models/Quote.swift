//
//  Quote.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 01.06.22.
//

import Foundation

struct Quote: Codable {
    let isin: String
    let bitPrice: Float
    let askPrice: Float
    let bitVolume: Int
    let askVolume: Int

    enum CodingKeys: String, CodingKey {
        case isin
        case bitPrice = "b"
        case askPrice = "a"
        case bitVolume = "b_v"
        case askVolume = "a_v"
    }
}
