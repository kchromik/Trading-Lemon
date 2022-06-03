//
//  URLRequest.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 24.05.22.
//

import Foundation

extension URLRequest {

    private static var header: [String: String] {
        return ["Authorization": "Bearer \(AppConfig.token)"]
    }

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
        case HEAD
    }

    func authenticated(header: [String: String] = URLRequest.header) -> URLRequest {
        var request = self
        header.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    func withHttp(method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }

    func withHttp(body: [String : String]) -> URLRequest {
        var request = self
        request.encodeParameters(parameters: body)
        return request
    }

    func withContentTypeHeader() -> URLRequest {
        var request = self
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func percentEscapeString(_ string: String) -> String {
      var characterSet = CharacterSet.alphanumerics
      characterSet.insert(charactersIn: "-._* ")

      return string
        .addingPercentEncoding(withAllowedCharacters: characterSet)!
        .replacingOccurrences(of: " ", with: "+")
        .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }

    mutating func encodeParameters(parameters: [String : String]) {
      let parameterArray = parameters.map { (arg) -> String in
        let (key, value) = arg
        return "\(key)=\(self.percentEscapeString(value))"
      }

      httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
