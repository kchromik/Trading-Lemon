//
//  Orders.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation


// MARK: - Result
struct Order: Codable {
    let id: String
    let status: String
    let side: String
    let title: String?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case side
        case title = "isin_title"
        case quantity
    }
}

struct OrderRequestBody: Encodable {

    let isin: String
    let expiresAt: String
    let side: String
    let quantity: Int
    let venue: String

    enum CodingKeys: String, CodingKey {
        case isin
        case expiresAt = "expires_at"
        case side
        case quantity
        case venue
    }

    var toData: Data {
        "isin=\(isin)?expiresAt=\(expiresAt)?side=\(side)?quantity=\(quantity)?venue=\(venue)".data(using: .utf8)!
    }
}
