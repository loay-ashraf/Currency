//
//  DefaultFetchConversionResultUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchConversionResultUseCase: FetchConversionResultUseCase {
    private let repository: CurrencyConverterRepository
    init(repository: CurrencyConverterRepository) {
        self.repository = repository
    }
    func execute(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        if base == "EUR" {
            return repository.fetchConversionRate(target)
                .map {
                    let result =  amount * $0
                    return .init(value: result)
                }
        } else if target == "EUR" {
            return repository.fetchConversionRate(base)
                .map {
                    let result =  amount * (1 / $0)
                    return .init(value: result)
                }
        } else {
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
}
