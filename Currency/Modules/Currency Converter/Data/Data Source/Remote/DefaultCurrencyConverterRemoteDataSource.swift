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
        let responseObservable: Observable<CurrencySymbolsJSON> = networkManager.request(using: requestRouter)
        let mappedResponseObservable = responseObservable
            .map {
                Array($0.symbols.keys)
            }
        return mappedResponseObservable
    }
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<Double> {
        let requestRouter = CurrencyConverterRouter.conversion(base: base, target: target, amount: amount)
        let responseObservable: Observable<CurrencyConvertResultJSON> = networkManager.request(using: requestRouter)
        let mappedResponseObservable = responseObservable
            .map {
                $0.result
            }
        return mappedResponseObservable
    }
}
