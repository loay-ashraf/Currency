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
    func fetchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        let requestRouter = CurrencyDetailsRouter.rate(date: date, target: target)
        let responseObservable: Observable<CurrencyRateHistoryJSONModel> = networkManager.request(using: requestRouter)
        return responseObservable
            .compactMap {
                $0.rates.values.first
            }
    }
}
