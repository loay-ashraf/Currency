//
//  FetchRateHistoryUseCaseTestCase.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 27/02/2023.
//
import XCTest
import RxSwift
@testable import Currency

final class FetchRateHistoryUseCaseTestCase: XCTestCase {
    var disposeBag: DisposeBag!
    /// Sut = System Under Test
    var sut: FetchRateHistoryUseCase!
    /// Mock = Fake injection
    var mock: CurrencyDetailsRepositoryMock!
    override func setUp() {
        super.setUp()
        mock = CurrencyDetailsRepositoryMock()
        sut = DefaultFetchRateHistoryUseCase(repository: mock)
        disposeBag = DisposeBag()
    }
    override func tearDown() {
        mock = nil
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    func testFetchCurrencyHistoricalConverts() {
        // Given
        let promise = XCTestExpectation(description: "Rate History is fetched.")
        // When
        sut.execute("EUR", "CAD")
            .subscribe(onNext: { [weak self] sutOutput in
                // Then
                guard let self = self,
                      let mockOutput = self.mock.rateHistoryResult else { return }
                XCTAssertTrue(self.mock.fetchRateHistoryCalled)
                XCTAssertEqual(self.mock.timesfetchHistoryRateCalled, 3)
                XCTAssertNotNil(sutOutput)
                XCTAssertNotNil(mockOutput)
                XCTAssertEqual(sutOutput.count, 3)
                XCTAssertEqual(sutOutput.count, mockOutput.count)
                XCTAssertEqual(sutOutput[0].base, "EUR")
                XCTAssertEqual(sutOutput[1].base, "EUR")
                XCTAssertEqual(sutOutput[2].base, "EUR")
                XCTAssertEqual(sutOutput[0].target, "CAD")
                XCTAssertEqual(sutOutput[1].target, "CAD")
                XCTAssertEqual(sutOutput[2].target, "CAD")
                XCTAssertEqual(sutOutput[0].date, "2023-05-29")
                XCTAssertEqual(sutOutput[1].date, "2023-05-28")
                XCTAssertEqual(sutOutput[2].date, "2023-05-27")
                promise.fulfill()
            }, onError: { _ in
                XCTFail("Failed to fetch rate history for last three days.")
            })
            .disposed(by: disposeBag)
        self.wait(for: [promise], timeout: 3.0)
    }
}
