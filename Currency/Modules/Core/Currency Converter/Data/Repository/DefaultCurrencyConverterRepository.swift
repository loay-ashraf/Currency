//
//  DefaultCurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRepository: CurrencyConverterRepository {
    // MARK: - Private Properties
    private let dataSource: CurrencyConverterRemoteDataSource
    // MARK: - Initializer
    init(dataSource: CurrencyConverterRemoteDataSource) {
        self.dataSource = dataSource
    }
    // MARK: - Instance Methods
    
    /// fetches available currency symbols
    ///
    /// - Returns: `Observable<[String]>` sequence that emits currency symbols or an error.
    func fetchSymbols() -> Observable<[String]> {
        let symbolsObservable = dataSource.fetchSymbols()
        return symbolsObservable
    }
    
    /// fetches conversion rate for specific target with default base "EUR"
    ///
    /// - Parameter target: `String` target currency symbol
    ///
    /// - Returns: `Observable<Double>` sequence that emits conversion rate or an error.
    func fetchConversionRate(_ target: String) -> Observable<Double> {
        let conversionRateObservable = dataSource.fetchConversionRate(target)
        return conversionRateObservable
    }
}
