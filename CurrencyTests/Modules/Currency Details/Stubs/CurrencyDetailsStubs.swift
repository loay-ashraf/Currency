//
//  CurrencyDetailsStubs.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 27/02/2023.
//
import XCTest
@testable import Currency
class CurrencyDetailsStubs {
    static var firstDayRateHistory: Double? {
        guard let path = Bundle.historicalUnitTests.path(forResource: "RateHistoryStub1", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let symbolsModel = try? decoder.decode(CurrencyRateHistoryJSONModel.self, from: data)
        return symbolsModel?.rates.values.first
    }
    static var secondDayRateHistory: Double? {
        guard let path = Bundle.historicalUnitTests.path(forResource: "RateHistoryStub2", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let symbolsModel = try? decoder.decode(CurrencyRateHistoryJSONModel.self, from: data)
        return symbolsModel?.rates.values.first
    }
    static var thirdDayRateHistory: Double? {
        guard let path = Bundle.historicalUnitTests.path(forResource: "RateHistoryStub3", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let symbolsModel = try? decoder.decode(CurrencyRateHistoryJSONModel.self, from: data)
        return symbolsModel?.rates.values.first
    }
//    func stubFamousCurrencyConverts() -> FamousCurrenciesEntity? {
//        guard let path = Bundle.famousCurrenciesUnitTests.path(forResource: "FamousCurrenciesStubs", ofType: "json"),
//            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
//            return nil
//        }
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        let symbolsModel = try? decoder.decode(FamousCurrenciesEntity.self, from: data)
//        return symbolsModel
//    }
}
extension Bundle {
    public class var historicalUnitTests: Bundle {
        return Bundle(for: HistoricalConvertsUseCaseTests.self)
    }
//    public class var famousCurrenciesUnitTests: Bundle {
//        return Bundle(for: FamousCurrencyConvertsUseCaseTests.self)
//    }
}
