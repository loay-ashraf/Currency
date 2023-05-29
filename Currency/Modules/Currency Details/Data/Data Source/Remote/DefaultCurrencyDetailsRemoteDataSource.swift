//
//  DefaultCurrencyDetailsRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

class DefaultCurrencyDetailsRemoteDataSource: CurrencyDetailsRemoteDataSource {
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]> {
        let requestRouter = CurrencyDetailsRouter.rate(targets: targets)
        let responseObservable: Observable<CurrencyRateJSONModel> = networkManager.request(using: requestRouter)
        return responseObservable
            .map {
                $0.rates
            }
    }
    func fetchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        let requestRouter = CurrencyDetailsRouter.rateHistory(date: date, target: target)
        let responseObservable: Observable<CurrencyRateHistoryRecordJSONModel> = networkManager.request(using: requestRouter)
        return responseObservable
            .compactMap {
                $0.rates.values.first
            }
    }
}
