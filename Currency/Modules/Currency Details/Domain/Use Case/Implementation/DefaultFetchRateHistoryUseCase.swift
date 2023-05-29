//
//  DefaultFetchRateHistoryUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import Foundation
import RxSwift

class DefaultFetchRateHistoryUseCase: FetchRateHistoryUseCase {
    // MARK: - Private Properties
    private let repository: CurrencyDetailsRepository
    // MARK: - Initializer
    init(repository: CurrencyDetailsRepository) {
        self.repository = repository
    }
    // MARK: - Instance Methods
    
    /// executes main task of the use case (fetches conversion rate history for a base and a target currency at a given date)
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - target: `String` target currency symbol
    ///
    /// - Returns: `Observable<[CurrencyRateHistoryRecord]>` sequence that emits conversion rate history or an error.
    func execute(_ base: String, _ target: String) -> Observable<[CurrencyRateHistoryRecord]> {
        let dates = computeThreeDaysDates()
        if base == "EUR" {
            return fetchDefaultBaseCurrencyRate(target, dates)
        } else if target == "EUR" {
            return fetchDefaultTargetCurrencyRate(base, dates)
        } else {
            return fetchCurrencyRate(base, target, dates)
        }
    }
    
    /// computes dates of past three days
    ///
    /// - Returns: `[String]` array of formatted dates' strings of past three days
    private func computeThreeDaysDates() -> [String] {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = .init(identifier: "en_US")
        let calendar = Calendar.current
        let todayDateString = dateFormatter.string(from: nowDate)
        let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: nowDate)!
        let yesterdayDateString = dateFormatter.string(from: yesterdayDate)
        let beforeYesterdayDate = calendar.date(byAdding: .day, value: -2, to: nowDate)!
        let beforeYesterdayDateString = dateFormatter.string(from: beforeYesterdayDate)
        return [todayDateString, yesterdayDateString, beforeYesterdayDateString]
    }
    
    /// fetches conversion rate history for a target currency if base is the default "EUR"
    ///
    /// - Parameters:
    ///   - target: `String` target currency symbol
    ///   - dates: `[String]` history dates strings
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion rate history or an error.
    private func fetchDefaultBaseCurrencyRate(_ target: String, _ dates: [String]) -> Observable<[CurrencyRateHistoryRecord]> {
        var observables: [Observable<CurrencyRateHistoryRecord>] = []
        for date in dates {
            let observable = repository.fectchRateHistory(date, target)
                .map({
                    CurrencyRateHistoryRecord.init(date: date, base: "EUR", target: target, value: $0)
                })
            observables.append(observable)
        }
        return Observable.zip(observables)
    }
    
    /// fetches conversion rate history for a base currency if target is the default "EUR"
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - dates: `[String]` history dates strings
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion rate history or an error.
    private func fetchDefaultTargetCurrencyRate(_ base: String, _ dates: [String]) -> Observable<[CurrencyRateHistoryRecord]> {
        var observables: [Observable<CurrencyRateHistoryRecord>] = []
        for date in dates {
            let observable = repository.fectchRateHistory(date, base)
                .map({
                    CurrencyRateHistoryRecord.init(date: date, base: base, target: "EUR", value: 1 / $0)
                })
            observables.append(observable)
        }
        return Observable.zip(observables)
    }
    
    /// fetches conversion rate history for a base and a target currency
    ///
    /// - Parameters:
    ///   - base: `String` base currency symbol
    ///   - target: `String` target currency symbol
    ///   - dates: `[String]` history dates strings
    ///
    /// - Returns: `Observable<CurrencyConversionResult>` sequence that emits conversion rate history or an error.
    private func fetchCurrencyRate(_ base: String, _ target: String, _ dates: [String]) -> Observable<[CurrencyRateHistoryRecord]> {
        var observables: [Observable<CurrencyRateHistoryRecord>] = []
        for date in dates {
            let baseRateObservable = repository.fectchRateHistory(date, base)
            let targetRateObservable = repository.fectchRateHistory(date, target)
            let zippedRateObservable = Observable.zip(baseRateObservable, targetRateObservable)
                .map {
                    let baseRate = $0.0
                    let targetRate = $0.1
                    return CurrencyRateHistoryRecord.init(date: date, base: base, target: target, value: targetRate / baseRate)
                }
            observables.append(zippedRateObservable)
        }
        return Observable.zip(observables)
    }
}
