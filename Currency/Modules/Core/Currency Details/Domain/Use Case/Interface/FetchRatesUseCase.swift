//
//  FetchRatesUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import RxSwift

protocol FetchRatesUseCase {
    func execute(_ base: String, _ targets: [String]) -> Observable<[CurrencyRate]>
}
