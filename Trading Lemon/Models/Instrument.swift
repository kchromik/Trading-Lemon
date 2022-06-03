//
//  Instrument.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation

struct Instrument: Codable {
    let isin: String
    let wkn: String
    let name: String
    let title: String
    let symbol: String
    let type: String
    let venues: [Venue]
}
