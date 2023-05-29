//
//  DefaultCurrencyDetailsRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

class DefaultCurrencyDetailsRemoteDataSource: CurrencyDetailsRemoteDataSource {
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    // MARK: - Initializer
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    // MARK: - Instance Methods
    
    /// fetches conversion rates for a set of target currencies using default base "EUR"
    ///
    /// - Parameter targets: `[String]` targets symbols
    ///
    /// - Returns: `Observable<[String: Double]>` sequence that emits conversion rates or an error.
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]> {
        let requestRouter = CurrencyDetailsRouter.rate(targets: targets)
        let responseObservable: Observable<CurrencyRateJSONModel> = networkManager.request(using: requestRouter)
        return responseObservable
            .map {
                $0.rates
            }
    }
    
    /// fetches conversion rate history record for af target currency using given date default base "EUR"
    ///
    /// - Parameters:
    ///   - date: `String` date for conversion rate history record
    ///   - target: `String` target currency symbol
    ///
    /// - Returns: `Observable<Double>` sequence that emits conversion rate or an error.
    func fetchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        let requestRouter = CurrencyDetailsRouter.rateHistory(date: date, target: target)
        let responseObservable: Observable<CurrencyRateHistoryRecordJSONModel> = networkManager.request(using: requestRouter)
        return responseObservable
            .compactMap {
                $0.rates.values.first
            }
    }
}
