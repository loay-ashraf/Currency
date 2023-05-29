//
//  CurrencyDetailsRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

protocol CurrencyDetailsRepository {
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]>
    func fectchRateHistory(_ date: String, _ target: String) -> Observable<Double>
}
