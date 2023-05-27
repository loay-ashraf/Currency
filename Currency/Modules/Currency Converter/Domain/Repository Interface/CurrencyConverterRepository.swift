//
//  CurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol CurrencyConverterRepository {
    func fetchSymbols() -> Observable<CurrencySymbols>
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult>
}
