//
//  CurrencyDetailsRepositoryMock.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 29/05/2023.
//
import XCTest
import RxSwift
@testable import Currency

class CurrencyDetailsRepositoryMock: CurrencyDetailsRepository {
    var fetchRateHistoryCalled = false
    var fetchRatesCalled = false
    var rateHistoryResult: [Double]?
    var ratesResult: [String: Double]?
    var timesfetchHistoryRateCalled: Int = 0
    func fectchRateHistory(_ date: String, _ target: String) -> Observable<Double> {
        fetchRateHistoryCalled = true
        timesfetchHistoryRateCalled += 1
        switch timesfetchHistoryRateCalled {
        case 1:
            return Observable.create { subscriber in
                let rateHistory = CurrencyDetailsStubs.firstDayRateHistory ?? 0.0
                self.rateHistoryResult = [rateHistory]
                subscriber.onNext(rateHistory)
                subscriber.onCompleted()
                return Disposables.create()
            }
        case 2:
            return Observable.create { subscriber in
                let rateHistory = CurrencyDetailsStubs.secondDayRateHistory ?? 0.0
                self.rateHistoryResult?.append(rateHistory)
                subscriber.onNext(rateHistory)
                subscriber.onCompleted()
                return Disposables.create()
            }
        case 3:
            return Observable.create { subscriber in
                let rateHistory = CurrencyDetailsStubs.thirdDayRateHistory ?? 0.0
                self.rateHistoryResult?.append(rateHistory)
                subscriber.onNext(rateHistory)
                subscriber.onCompleted()
                return Disposables.create()
            }
        default:
            return Observable.empty()
        }
    }
    func fetchRate(_ targets: [String]) -> Observable<[String: Double]> {
        fetchRatesCalled = true
        return Observable.create { subscriber in
            let rates = CurrencyDetailsStubs.rates ?? [:]
            self.ratesResult = rates
            subscriber.onNext(rates)
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
}
