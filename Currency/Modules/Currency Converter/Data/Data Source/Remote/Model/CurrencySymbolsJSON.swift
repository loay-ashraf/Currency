//
//  CurrencySymbolsJSON.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

// MARK: - CurrencySymbolsJSON
struct CurrencySymbolsJSON: Codable {
    let success: Bool
    let symbols: [String: String]
}
