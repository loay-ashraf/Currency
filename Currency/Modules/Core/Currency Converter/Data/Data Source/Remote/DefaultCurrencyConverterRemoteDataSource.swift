//
//  DefaultCurrencyConverterRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRemoteDataSource: CurrencyConverterRemoteDataSource {
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    // MARK: - Initializer
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    // MARK: - Instance Methods
    
    /// fetches available currency symbols
    ///
    /// - Returns: `Observable<[String]>` sequence that emits currency symbols or an error.
    func fetchSymbols() -> Observable<[String]> {
        let requestRouter = CurrencyConverterRouter.symbols
        let responseObservable: Observable<CurrencySymbolsJSONModel> = networkManager.request(using: requestRouter)
        let mappedResponseObservable = responseObservable
            .map {
                Array($0.symbols.keys)
            }
        return mappedResponseObservable
    }
    
    /// fetches conversion rate for specific target with default base "EUR"
    ///
    /// - Parameter target: `String` target currency symbol
    ///
    /// - Returns: `Observable<Double>` sequence that emits conversion rate or an error.
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
