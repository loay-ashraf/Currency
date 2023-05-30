//
//  CurrencyConverterRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol CurrencyConverterRepository {
    func fetchSymbols() -> Observable<[String]>
    func fetchConversionRate(_ target: String) -> Observable<Double>
}
