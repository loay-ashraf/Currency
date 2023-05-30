//
//  CurrencyDetailsRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

protocol CurrencyDetailsRemoteDataSource {
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]>
    func fetchRateHistory(_ date: String, _ target: String) -> Observable<Double>
}
