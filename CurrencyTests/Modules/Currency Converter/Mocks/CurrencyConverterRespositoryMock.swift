//
//  CurrencyConverterRespositoryMock.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 28/05/2023.
//
import XCTest
import RxSwift
@testable import Currency
class CurrencyConverterRespositoryMock: CurrencyConverterRepository {
    var fetchSymbolsCalled = false
    var fetchConversionRateCalled = false
    var symbolsResult: [String]?
    var rateResult: Double?
    func fetchSymbols() -> Observable<[String]> {
        fetchSymbolsCalled = true
        return Observable.create { subscriber in
            let symbols = CurrencyConverterStubs.symbolsStub ?? []
            self.symbolsResult = symbols
            subscriber.onNext(symbols)
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    func fetchConversionRate(_ target: String) -> Observable<Double> {
        fetchConversionRateCalled = true
        return Observable.create { subscriber in
            let rate = CurrencyConverterStubs.rateStub ?? 0.0
            self.rateResult = rate
            subscriber.onNext(rate)
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
}
