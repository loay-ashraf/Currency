//
//  CurrencyConverterRouter.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

enum CurrencyConverterRouter: NetworkRouter {
    case symbols
    case conversion(base: String, target: String, amount: Double)
    var scheme: HTTPScheme {
        .http
    }
    var method: HTTPMethod {
        .get
    }
    var domain: String {
        "data.fixer.io"
    }
    var path: String {
        switch self {
        case .symbols:
            return "api/symbols"
        case .conversion:
            return "api/convert"
        }
    }
    var headers: [String : String] {
        ["Accept": "application/json"]
    }
    var parameters: [String : String]? {
        var parameters: [String: String] = ["access_key": "7d80b5334c7a102a84071ac77c135d63"]
        switch self {
        case .symbols:
            return parameters
        case .conversion(let base, let target, let amount):
            parameters["from"] = base
            parameters["to"] = target
            parameters["amount"] = "\(amount)"
            return parameters
        }
    }
    var body: [String : Any]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
