//
//  DefaultCurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRepository: CurrencyConverterRepository {
    func fetchSymbols() -> Observable<[String]> {
        <#code#>
    }
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<Double> {
        <#code#>
    }
}
