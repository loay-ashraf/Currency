//
//  CurrencyConversionRateJSONModel.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

// MARK: - CurrencyConvertRateJSONModel
struct CurrencyConversionRateJSONModel: Codable {
    let success: Bool
    let rates: [String: Double]
}
