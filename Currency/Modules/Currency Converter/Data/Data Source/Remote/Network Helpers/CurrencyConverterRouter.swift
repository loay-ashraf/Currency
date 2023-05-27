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
        .https
    }
    var method: HTTPMethod {
        .get
    }
    var domain: String {
        "api.github.com"
    }
    var path: String {
        "users"
    }
    var headers: [String : String] {
        ["Accept": "application/vnd.github+json"]
    }
    var parameters: [String : String]? {
        nil
    }
    var body: [String : Any]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
