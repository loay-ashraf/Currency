//
//  CurrencyConvertResultJSON.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

// MARK: - CurrencyConvertResultJSON
struct CurrencyConvertResultJSON: Codable {
    let success: Bool
    let rates: [String: Double]
//    let query: Query
//    let info: Info
//    let historical, date: String
//    let result: Double
//    struct Info: Codable {
//        let timestamp: Int
//        let rate: Double
//    }
//    struct Query: Codable {
//        let from, to: String
//        let amount: Int
//    }
}
