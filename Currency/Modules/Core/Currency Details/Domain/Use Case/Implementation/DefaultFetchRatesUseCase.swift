//
//  DefaultFetchRatesUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import RxSwift

class DefaultFetchRatesUseCase: FetchRatesUseCase {
    // MARK: - Private Properties
    private let repository: CurrencyDetailsRepository
    // MARK: - Initializer
    init(repository: CurrencyDetailsRepository) {
        self.repository = repository
    }
    // MARK: - Instance Methods
    
    /// executes main task of the use case (fetches conversion rates for a base and a set of target currencies)
    /// 
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - targets: `[String]` target currencies symbols
    ///
    /// - Returns: `Observable<[CurrencyRate]>` sequence that emits conversion rates or an error.
    func execute(_ base: String, _ targets: [String]) -> Observable<[CurrencyRate]> {
        if base == Constants.defaultBaseCurrency {
            return fetchDefaultBaseCurrencyRate(targets)
        } else {
            return fetchBaseCurrencyRate(base, targets)
        }
    }
    
    /// fetches conversion rates for default base "EUR" and a set of target currencies
    ///
    /// - Parameters:
    ///   - targets: `[String]` target currencies symbols
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion rates or an error.
    private func fetchDefaultBaseCurrencyRate(_ targets: [String]) -> Observable<[CurrencyRate]> {
        let observable = repository.fetchRate(targets)
        return observable
            .map {
                $0.reduce(into: [CurrencyRate]()) {
                    $0.append(.init(base: Constants.defaultBaseCurrency, target: $1.key, value: $1.value))
                }
            }
    }
    
    /// fetches conversion rates for a base and a set of target currencies
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - targets: `[String]` target currencies symbols
    ///
    /// - Returns: `Observable<[CurrencyRate]>` sequence that emits conversion rates or an error.
    private func fetchBaseCurrencyRate(_ base: String, _ targets: [String]) -> Observable<[CurrencyRate]> {
        var observables: [Observable<CurrencyRate>] = []
        for target in targets {
            let baseRateObservable = repository.fetchRate([base])
            let targetRateObservable = repository.fetchRate([target])
            let zippedRateObservable = Observable.zip(baseRateObservable, targetRateObservable)
                .map {
                    let baseRate = $0.0.values.first ?? 1.0
                    let targetRate = $0.1.values.first ?? 1.0
                    return CurrencyRate.init(base: base, target: target, value: targetRate / baseRate)
                }
            observables.append(zippedRateObservable)
        }
        return Observable.zip(observables)
    }
}
