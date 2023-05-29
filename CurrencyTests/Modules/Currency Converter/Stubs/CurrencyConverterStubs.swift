//
//  RepoStubGenerator.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 27/02/2023.
//
import XCTest
@testable import Currency
class CurrencyConverterStubs {
    static var symbolsStub: [String]? {
        guard let path = Bundle.symbolUnitTest.path(forResource: "SymbolsStub", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let symbolsModel = try? decoder.decode(CurrencySymbolsJSONModel.self, from: data)
        guard let symbolsValues = symbolsModel?.symbols.values else {
            return nil
        }
        let symbolsArray: [String] = Array(symbolsValues)
        return symbolsArray
    }
    static var rateStub: Double? {
        guard let path = Bundle.convertsUnitTest.path(forResource: "RateStub", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        let rateModel = try? decoder.decode(CurrencyConversionRateJSONModel.self, from: data)
        let firstRate = rateModel?.rates.values.first
        return firstRate
    }
}
extension Bundle {
    public class var symbolUnitTest: Bundle {
        return Bundle(for: FetchSymbolsUseCaseTestCase.self)
    }
    public class var convertsUnitTest: Bundle {
        return Bundle(for: FetchConversionRateUseCaseTestCase.self)
    }
}
