//
//  DefaultCurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRepository: CurrencyConverterRepository {
    private let dataSource: CurrencyConverterRemoteDataSource
    init(dataSource: CurrencyConverterRemoteDataSource) {
        self.dataSource = dataSource
    }
    func fetchSymbols() -> Observable<CurrencySymbols> {
        let symbolsObservable = dataSource.fetchSymbols()
        let mappedSymbolsObservable = symbolsObservable
            .map {
                CurrencySymbols(value: $0)
            }
        return mappedSymbolsObservable
    }
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        let conversionResultObservable = dataSource.fetchConversionResult(base, target, amount)
        let mappedConversionResultObservable = conversionResultObservable
            .map {
                CurrencyConversionResult(value: $0)
            }
        return mappedConversionResultObservable
    }
}
