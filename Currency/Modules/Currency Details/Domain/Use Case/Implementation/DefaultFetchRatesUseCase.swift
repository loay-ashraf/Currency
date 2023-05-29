//
//  DefaultFetchRatesUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import RxSwift

class DefaultFetchRatesUseCase: FetchRatesUseCase {
    private let repository: CurrencyDetailsRepository
    init(repository: CurrencyDetailsRepository) {
        self.repository = repository
    }
    func execute(_ base: String, _ targets: [String]) -> Observable<[CurrencyRate]> {
        if base == "EUR" {
            return fetchDefaultBaseCurrencyRate(targets)
        } else {
            return fetchBaseCurrencyRate(base, targets)
        }
    }
    private func fetchDefaultBaseCurrencyRate(_ targets: [String]) -> Observable<[CurrencyRate]> {
        let observable = repository.fetchRate(targets)
        return observable
            .map {
                $0.reduce(into: [CurrencyRate]()) {
                    $0.append(.init(base: "EUR", target: $1.key, value: $1.value))
                }
            }
    }
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
