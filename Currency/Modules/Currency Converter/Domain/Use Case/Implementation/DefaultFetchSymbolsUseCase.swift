//
//  DefaultFetchSymbolsUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchSymbolsUseCase: FetchSymbolsUseCase {
    private let repository: CurrencyConverterRepository
    init(repository: CurrencyConverterRepository) {
        self.repository = repository
    }
    func execute() -> Observable<CurrencySymbols> {
        repository.fetchSymbols()
    }
}
