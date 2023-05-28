//
//  FetchHistoricalRatesUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

protocol FetchRateHistoryUseCase {
    func execute(_ base: String, _ target: String) -> Observable<CurrencyRateHistory>
}
