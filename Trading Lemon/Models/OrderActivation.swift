//
//  OrderActivation.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import Foundation

struct OrderActivation: Codable {

    let status: String
    var success: Bool {
        status == "ok"
    }
}
