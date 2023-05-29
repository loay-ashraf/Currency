//
//  DefaultFetchConversionResultUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchConversionResultUseCase: FetchConversionResultUseCase {
    // MARK: - Private Properties
    private let repository: CurrencyConverterRepository
    // MARK: - Initializer
    init(repository: CurrencyConverterRepository) {
        self.repository = repository
    }
    // MARK: - Instance Methods
    
    /// executes main task of the use case (fetches available currency symbols)
    /// 
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - target: `String` target currency symbol
    ///   - amount: `Double` base currency amount
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion result or an error.
    func execute(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        if base == "EUR" {
            return convertDefaultBaseCurrency(target, amount)
        } else if target == "EUR" {
            return convertDefaultTargetCurrency(base, amount)
        } else {
            return convertCurrency(base, target, amount)
        }
    }
    
    /// converts base currency to target currency if base is the default "EUR"
    ///
    /// - Parameters:
    ///   - target: `String` target currency symbol
    ///   - amount: `Double` base currency amount
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion result or an error.
    private func convertDefaultBaseCurrency(_ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        return repository.fetchConversionRate(target)
            .map {
                let result =  amount * $0
                return .init(value: result)
            }
    }
    
    /// converts base currency to target currency if target is the default "EUR"
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - amount: `Double` base currency amount
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion result or an error.
    private func convertDefaultTargetCurrency(_ base: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        return repository.fetchConversionRate(base)
            .map {
                let result =  amount * (1 / $0)
                return .init(value: result)
            }
    }
    
    
    /// converts base currency to target currency
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - target: `String` target currency symbol
    ///   - amount: `Double` base currency amount
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion result or an error.
    private func convertCurrency(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        let baseRateObservable = repository.fetchConversionRate(base)
        let targetRateObservable = repository.fetchConversionRate(target)
        let zippedRateObservable = Observable.zip(baseRateObservable, targetRateObservable)
        return zippedRateObservable
            .map {
                let baseRate = $0.0
                let targetRate = $0.1
                let actualRate = targetRate / baseRate
                let result = amount * actualRate
                return .init(value: result)
            }
    }
}
