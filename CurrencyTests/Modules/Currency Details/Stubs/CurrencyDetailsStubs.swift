//
//  CurrencyDetailsStubs.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 29/05/2023.
//
import XCTest
@testable import Currency
class CurrencyDetailsStubs {
    static var firstDayRateHistory: Double? {
        guard let path = Bundle.rateHistoryTests.path(forResource: "RateHistoryStub1", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let rateHistoryModel = try? decoder.decode(CurrencyRateHistoryRecordJSONModel.self, from: data)
        return rateHistoryModel?.rates.values.first
    }
    static var secondDayRateHistory: Double? {
        guard let path = Bundle.rateHistoryTests.path(forResource: "RateHistoryStub2", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let rateHistoryModel = try? decoder.decode(CurrencyRateHistoryRecordJSONModel.self, from: data)
        return rateHistoryModel?.rates.values.first
    }
    static var thirdDayRateHistory: Double? {
        guard let path = Bundle.rateHistoryTests.path(forResource: "RateHistoryStub3", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let rateHistoryModel = try? decoder.decode(CurrencyRateHistoryRecordJSONModel.self, from: data)
        return rateHistoryModel?.rates.values.first
    }
    static var rates: [String: Double]? {
        guard let path = Bundle.ratesUnitTests.path(forResource: "RatesStub", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let ratesModel = try? decoder.decode(CurrencyRateJSONModel.self, from: data)
        return ratesModel?.rates
    }
}
extension Bundle {
    public class var rateHistoryTests: Bundle {
        return Bundle(for: FetchRateHistoryUseCaseTestCase.self)
    }
    public class var ratesUnitTests: Bundle {
        return Bundle(for: FetchRatesUseCaseTestCase.self)
    }
}
