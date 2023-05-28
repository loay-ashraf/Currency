//
//  FetchSymbolsUseCaseTestCase.swift
//  CurrencyTests
//
//  Created by Loay Ashraf on 27/02/2023.
//
import XCTest
import RxSwift
@testable import Currency
class FetchSymbolsUseCaseTestCase: XCTestCase {
    var disposeBag: DisposeBag!
    /// Sut = System Under Test
    var sut: FetchSymbolsUseCase!
    /// Mock = Fake injection
    var mock: CurrencyConverterRespositoryMock!
    override func setUp() {
        super.setUp()
        mock = CurrencyConverterRespositoryMock()
        sut = DefaultFetchSymbolsUseCase(repository: mock)
        disposeBag = DisposeBag()
    }
    override func tearDown() {
        mock = nil
        sut = nil
        disposeBag = nil
        super.tearDown()
    }
    func testFetchCurrencySymbols() {
        // Given
        let promise = XCTestExpectation(description: "Symbols are fetched.")
        // When
        sut.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] symbols in
                // Then
                guard let self = self,
                      let symbolsResult = self.mock.symbolsResult?.sorted() else { return }
                XCTAssertTrue(self.mock.fetchSymbolsCalled)
                XCTAssertNotNil(symbols)
                XCTAssertNotNil(symbolsResult)
                XCTAssertEqual(symbols.value.sorted()[0].count, symbolsResult[0].count)
                XCTAssertEqual(symbols.value.count, symbolsResult.count)
                XCTAssertEqual(symbols.value.sorted(), symbolsResult)
                promise.fulfill()
            }, onError: { _ in
                XCTFail("Failed to fetch symbols.")
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 3.0)
    }
}
