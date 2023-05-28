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
    func fetchSymbols() -> Observable<[String]> {
        let symbolsObservable = dataSource.fetchSymbols()
        return symbolsObservable
    }
    func fetchConversionRate(_ target: String) -> Observable<Double> {
        let conversionRateObservable = dataSource.fetchConversionRate(target)
        return conversionRateObservable
    }
}
