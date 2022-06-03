//
//  NetworkAdapter.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 30.03.22.
//

import Foundation

class NetworkAdapter {

    func send<T: Codable>(request: URLRequest, type: T.Type) async throws -> T {
        let data = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(type, from: data.0)
    }
}
