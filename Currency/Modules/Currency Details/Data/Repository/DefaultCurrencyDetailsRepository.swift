//
//  DefaultCurrencyDetailsRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

class DefaultCurrencyDetailsRepository: CurrencyDetailsRepository {
    private let dataSource: CurrencyDetailsRemoteDataSource
    init(dataSource: CurrencyDetailsRemoteDataSource) {
        self.dataSource = dataSource
    }
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]> {
        dataSource.fetchRate(targets)
    }
    func fectchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        dataSource.fetchRateHistory(date, target)
    }
}
