//
//  CurrencyRateJSONModel.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import Foundation

// MARK: - CurrencyRateJSONModel
struct CurrencyRateJSONModel: Codable {
    let success: Bool
    let rates: [String: Double]
}
