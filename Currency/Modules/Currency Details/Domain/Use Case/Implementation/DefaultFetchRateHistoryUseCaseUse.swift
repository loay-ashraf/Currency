//
//  DefaultFetchRateHistoryUseCaseUse.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

class DefaultFetchRateHistoryUseCaseUse: FetchRateHistoryUseCase {
    private let repository: CurrencyDetailsRepository
    init(repository: CurrencyDetailsRepository) {
        self.repository = repository
    }
    func execute(_ base: String, _ target: String) -> Observable<CurrencyRateHistory> {
        repository.fectchRateHistory(base, target)
            .map {
                .init(base: base, target: target, values: $0)
            }
    }
}
