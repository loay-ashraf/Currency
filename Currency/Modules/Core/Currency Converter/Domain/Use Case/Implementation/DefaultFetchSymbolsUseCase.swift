//
//  DefaultFetchSymbolsUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchSymbolsUseCase: FetchSymbolsUseCase {
    // MARK: - Private Properties
    private let repository: CurrencyConverterRepository
    // MARK: - Initializer
    init(repository: CurrencyConverterRepository) {
        self.repository = repository
    }
    // MARK: - Instance Methods
    
    /// executes main task of the use case (fetches available currency symbols)
    /// 
    /// - Returns: `Observable<CurrencySymbols>` sequence that emits conversion result or an error.
    func execute() -> Observable<CurrencySymbols> {
        repository.fetchSymbols()
            .map {
                .init(value: $0)
            }
    }
}
