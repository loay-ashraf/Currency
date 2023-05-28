//
//  CurrencyConverterRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

protocol CurrencyConverterRemoteDataSource {
    func fetchSymbols() -> Observable<[String]>
    func fetchConversionRate(_ target: String) -> Observable<Double>
}
