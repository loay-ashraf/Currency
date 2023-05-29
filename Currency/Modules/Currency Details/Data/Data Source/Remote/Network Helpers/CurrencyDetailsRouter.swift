//
//  CurrencyDetailsRouter.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import Foundation

enum CurrencyDetailsRouter: NetworkRouter {
    case rate(targets: [String])
    case rateHistory(date: String, target: String)
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
        case .rate:
            return "api/latest"
        case .rateHistory(let date, _):
            return "api/\(date)"
        }
    }
    var headers: [String : String] {
        ["Accept": "application/json"]
    }
    var parameters: [String : String]? {
        var parameters: [String: String] = ["access_key": "7d80b5334c7a102a84071ac77c135d63"]
        parameters["base"] = Constants.defaultBaseCurrency
        switch self {
        case .rate(let targets):
            parameters["symbols"] = targets.joined(separator: ",")
        case .rateHistory(_, let target):
            parameters["symbols"] = target
        }
        return parameters
    }
    var body: [String : Any]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
