//
//  DefaultCurrencyConverterRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import RxSwift

class DefaultCurrencyConverterRemoteDataSource: CurrencyConverterRemoteDataSource {
    func fetchSymbols() -> Observable<CurrencySymbolsJSON> {
        NetworkManager.shared.request(using: CurrencyConverterRouter.symbols)
    }
    func fetchConversionResult(_ base: String, _ target: String, _ amount: Double) -> Observable<CurrencyConvertResultJSON> {
        NetworkManager.shared.request(using: CurrencyConverterRouter.conversion(base: base, target: target, amount: amount))
    }
}
