//
//  DefaultCurrencyConverterRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRemoteDataSource: CurrencyConverterRemoteDataSource {
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    func fetchSymbols() -> Observable<[String]> {
        let requestRouter = CurrencyConverterRouter.symbols
        let responseObservable: Observable<CurrencySymbolsJSONModel> = networkManager.request(using: requestRouter)
        let mappedResponseObservable = responseObservable
            .map {
                Array($0.symbols.keys)
            }
        return mappedResponseObservable
    }
    func fetchConversionRate(_ target: String) -> Observable<Double> {
        let requestRouter = CurrencyConverterRouter.rate(target: target)
        let responseObservable: Observable<CurrencyConversionRateJSONModel> = networkManager.request(using: requestRouter)
        let mappedResponseObservable = responseObservable
            .map {
                $0.rates.values.first ?? 0.0
            }
        return mappedResponseObservable
    }
}
