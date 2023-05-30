//
//  FetchSymbolsUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol FetchSymbolsUseCase {
    func execute() -> Observable<CurrencySymbols>
}
