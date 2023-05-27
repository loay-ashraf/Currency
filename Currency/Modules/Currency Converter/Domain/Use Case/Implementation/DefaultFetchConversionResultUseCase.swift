//
//  DefaultFetchConversionResultUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchConversionResultUseCase: FetchConversionResultUseCase {
    private let respository: CurrencyConverterRepository
    init(respository: CurrencyConverterRepository) {
        self.respository = respository
    }
    func execute(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult> {
        respository.fetchConversionResult(base, target, amount)
    }
}
