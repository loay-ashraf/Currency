//
//  CurrencyConverterRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol CurrencyConverterRemoteDataSource {
    func fetchSymbols() -> Observable<[String]>
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<Double>
}
