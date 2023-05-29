//
//  CurrencyDetailsViewModel.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyDetailsViewModel {
    private let baseCurrency: String
    private let targetCurrency: String
    private let targetCurrencies: [String] = [
        "USD",
        "CAD",
        "GBP",
        "CHF",
        "JPY",
        "SAR",
        "QAR",
        "AED",
        "KWD",
        "EGP"
    ]
    private let fetchRateHistoryUseCase: FetchRateHistoryUseCase
    private let fetchRatesUseCase: FetchRatesUseCase
    private let disposeBag = DisposeBag()
    // MARK: - View State
    private(set) var viewState: PublishRelay<CurrencyConverterViewState> = .init()
    // MARK: - Outputs
    private(set) var rateHistory: Driver<[CurrencyRateHistoryRecord]>!
    private(set) var rates: Driver<[CurrencyRate]>!
    private(set) var error: Driver<NetworkError>!
    init(baseCurrency: String, targetCurrency: String, fetchRateHistoryUseCase: FetchRateHistoryUseCase, fetchRatesUseCase: FetchRatesUseCase) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.fetchRateHistoryUseCase = fetchRateHistoryUseCase
        self.fetchRatesUseCase = fetchRatesUseCase
        setupBindings()
    }
    private func setupBindings() {
        // Bind View State to Outputs
        setupViewStateBindings()
        // Bind Outputs to View State
        setupOutputBindings()
    }
    private func setupViewStateBindings() {
        let rateHistoryObservable = setupRateHistoryObservable()
        let ratesObservable = setupRatesObservable()
        let mergedErrorsObservable = Observable.merge([rateHistoryObservable.compactMap { $0.error as? NetworkError },
                                                       ratesObservable.compactMap { $0.error as? NetworkError }])
        rateHistory = rateHistoryObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        rates = ratesObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        error = mergedErrorsObservable
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
    }
    private func setupRateHistoryObservable() -> Observable<Event<[CurrencyRateHistoryRecord]>> {
        let rateHistoryObservable = viewState
            .filter( { ![.idle, .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let rateHistoryObservable = self.fetchRateHistoryUseCase.execute(self.baseCurrency, self.targetCurrency)
                    .materialize()
                return rateHistoryObservable
            }
            .share()
        return rateHistoryObservable
    }
    private func setupRatesObservable() -> Observable<Event<[CurrencyRate]>> {
        let ratesObservable = viewState
            .filter( { ![.idle, .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let ratesObservable = self.fetchRatesUseCase.execute(self.baseCurrency, self.targetCurrencies)
                    .materialize()
                return ratesObservable
            }
            .share()
        return ratesObservable
    }
    private func setupOutputBindings() {
        rateHistory
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        rates
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        error
            .asObservable()
            .map({ _ in .error })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
}
