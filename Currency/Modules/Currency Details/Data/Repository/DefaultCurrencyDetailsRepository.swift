//
//  DefaultCurrencyDetailsRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

class DefaultCurrencyDetailsRepository: CurrencyDetailsRepository {
    // MARK: - Private Properties
    private let dataSource: CurrencyDetailsRemoteDataSource
    // MARK: - Initializer
    init(dataSource: CurrencyDetailsRemoteDataSource) {
        self.dataSource = dataSource
    }
    // MARK: - Instance Methods
    
    /// fetches conversion rates for a set of target currencies using default base "EUR"
    ///
    /// - Parameter targets: `[String]` targets symbols
    ///
    /// - Returns: `Observable<[String: Double]>` sequence that emits conversion rates or an error.
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]> {
        dataSource.fetchRate(targets)
    }
    
    /// fetches conversion rate history record for af target currency using given date default base "EUR"
    ///
    /// - Parameters:
    ///   - date: `String` date for conversion rate history record
    ///   - target: `String` target currency symbol
    ///
    /// - Returns: `Observable<Double>` sequence that emits conversion rate or an error.
    func fectchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        dataSource.fetchRateHistory(date, target)
    }
}
