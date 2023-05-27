//
//  DefaultFetchSymbolsUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultFetchSymbolsUseCase: FetchSymbolsUseCase {
    func execute() -> Observable<CurrencySymbols> {
        Observable.just(CurrencySymbols.init(value: []))
    }
}
