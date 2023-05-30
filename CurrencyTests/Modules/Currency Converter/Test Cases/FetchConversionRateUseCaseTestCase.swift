//
//  FetchConversionRateUseCaseTestCase.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 28/05/2023.
//
import XCTest
import RxSwift
@testable import Currency
class FetchConversionRateUseCaseTestCase: XCTestCase {
    var disposeBag: DisposeBag!
    /// Sut = System Under Test
    var sut: FetchConversionResultUseCase!
    /// Mock = Fake injection
    var mock: CurrencyConverterRespositoryMock!
    override func setUp() {
        super.setUp()
        mock = CurrencyConverterRespositoryMock()
        sut = DefaultFetchConversionResultUseCase(repository: mock)
        disposeBag = DisposeBag()
    }
    override func tearDown() {
        mock = nil
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    func testFetchConvertedCurrency() {
        // Given
        let promise = XCTestExpectation(description: "Currency Conversion Rate is fetched.")
        // When
        sut.execute("EUR", "USD", 5.0)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] sutOutput in
                // Then
                guard let self = self,
                      let mockOutput = self.mock.rateResult  else { return }
                XCTAssertTrue(self.mock.fetchConversionRateCalled)
                XCTAssertNotNil(mockOutput)
                XCTAssertNotNil(sutOutput.value)
                XCTAssertEqual(mockOutput * 5.0, sutOutput.value)
                promise.fulfill()
            }, onError: { _ in
                XCTFail("Failed to fetch the conversion rate.")
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 3.0)
    }
}
