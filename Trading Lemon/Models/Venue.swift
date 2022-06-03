//
//  Venue.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation

struct Venue: Codable {
    let name: String
    let title: String
    let mic: String
    let is_open: Bool
    let tradable: Bool
    let currency: String
}
