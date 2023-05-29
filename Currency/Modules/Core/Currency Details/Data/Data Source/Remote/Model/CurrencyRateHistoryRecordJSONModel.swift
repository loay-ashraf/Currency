//
//  CurrencyRateHistoryRecordJSONModel.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import Foundation

// MARK: - CurrencyRateHistoryJSON
struct CurrencyRateHistoryRecordJSONModel: Codable {
    let success, historical: Bool
    let date: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
