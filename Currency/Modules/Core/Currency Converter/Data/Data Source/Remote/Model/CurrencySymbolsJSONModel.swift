//
//  CurrencySymbolsJSONModel.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

// MARK: - CurrencySymbolsJSONModel
struct CurrencySymbolsJSONModel: Codable {
    let success: Bool
    let symbols: [String: String]
}
