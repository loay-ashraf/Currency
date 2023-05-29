//
//  FetchRatesUseCaseTestCase.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 29/05/2023.
//
import XCTest
import RxSwift
@testable import Currency

final class FetchRatesUseCaseTestCase: XCTestCase {
    var disposeBag: DisposeBag!
    /// Sut = System Under Test
    var sut: FetchRatesUseCase!
    /// Mock = Fake injection
    var mock: CurrencyDetailsRepositoryMock!
    override func setUp() {
        super.setUp()
        mock = CurrencyDetailsRepositoryMock()
        sut = DefaultFetchRatesUseCase(repository: mock)
        disposeBag = DisposeBag()
    }
    override func tearDown() {
        mock = nil
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    func testFetchFamousCurrencyRates() {
        // Given
        let promise = XCTestExpectation(description: "Rates are fetched")
        // When
        sut.execute("EUR", [
            "USD",
            "CAD",
            "GBP",
            "CHF",
            "JPY",
            "SAR",
            "QAR",
            "AED",
            "KWD",
            "EGP"])
            .subscribe(onNext: { [weak self] sutOutput in
                // Then
                guard let self = self,
                      let mockOutput = self.mock.ratesResult else {return}
                XCTAssertTrue(self.mock.fetchRatesCalled)
                XCTAssertNotNil(mockOutput)
                XCTAssertNotNil(sutOutput)
                XCTAssertEqual(mockOutput.count, 10)
                XCTAssertEqual(sutOutput.count, 10)
                XCTAssertEqual(mockOutput.count, sutOutput.count)
                promise.fulfill()
            }, onError: { _ in
                XCTFail("Failed to fetch rates.")
            })
            .disposed(by: disposeBag)
        self.wait(for: [promise], timeout: 3.0)
    }
}
