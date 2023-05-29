//
//  FetchConversionResultUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol FetchConversionResultUseCase {
    func execute(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConversionResult>
}
