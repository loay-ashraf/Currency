//
//  CurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

protocol CurrencyConverterRepository {
    associatedtype SymbolsReturnType
    associatedtype ConversionResultReturnType
    func fetchSymbols() -> SymbolsReturnType
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> ConversionResultReturnType
}
