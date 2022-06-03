//
//  AppConfig.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

class AppConfig {

    static let positiveColor = Color(#colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1))
    static let negativeColor = Color(#colorLiteral(red: 1, green: 0.2310302541, blue: 0.1019607857, alpha: 1))
    static let tradeButtonColor = Color(#colorLiteral(red: 0.1503154363, green: 0.7585714334, blue: 0.2666666806, alpha: 1))
    static let darkBackground = Color(#colorLiteral(red: 0.01544039883, green: 0.1381136477, blue: 0.1901211143, alpha: 1))
    static let lightBackground = Color(#colorLiteral(red: 0.02540239878, green: 0.1925905645, blue: 0.2916927338, alpha: 1))
    static let lightText = Color(#colorLiteral(red: 1, green: 1, blue: 0.9999999404, alpha: 1))
    static let tint = Color(#colorLiteral(red: 0.1699005663, green: 0.8855128884, blue: 0.5062538385, alpha: 1))


    static let token = "ADD HERE YOUR API TOKEN"

    static let marketDataBaseURL = "https://data.lemon.markets/v1/"
    static let tradingBaseURL = "https://paper-trading.lemon.markets/v1/"
}
