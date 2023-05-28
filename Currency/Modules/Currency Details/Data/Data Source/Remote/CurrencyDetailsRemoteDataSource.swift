//
//  CurrencyDetailsRemoteDataSource.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

protocol CurrencyDetailsRemoteDataSource {
    func fetchRateHistory(_ date: String, _ target: String) -> Observable<CurrencyRateHistoryJSONModel>
}
