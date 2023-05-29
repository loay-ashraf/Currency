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
    // MARK: - Private Properties
    private let baseCurrency: String
    private let targetCurrency: String
    private let targetCurrencies: [String] = Constants.popularTargetCurrencies
    private let fetchRateHistoryUseCase: FetchRateHistoryUseCase
    private let fetchRatesUseCase: FetchRatesUseCase
    private let disposeBag = DisposeBag()
    // MARK: - View State
    private(set) var viewState: PublishRelay<CurrencyDetailsViewState> = .init()
    // MARK: - Outputs
    private(set) var rateHistory: Driver<[CurrencyRateHistoryRecord]>!
    private(set) var rates: Driver<[CurrencyRate]>!
    private(set) var error: Driver<NetworkError>!
    // MARK: - Initializer
    init(baseCurrency: String, targetCurrency: String, fetchRateHistoryUseCase: FetchRateHistoryUseCase, fetchRatesUseCase: FetchRatesUseCase) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.fetchRateHistoryUseCase = fetchRateHistoryUseCase
        self.fetchRatesUseCase = fetchRatesUseCase
        setupBindings()
    }
    // MARK: - Instance Methods
    
    /// sets up reacive bindings for view state and outputs
    private func setupBindings() {
        // Bind View State to Outputs
        setupViewStateBindings()
        // Bind Outputs to View State
        setupOutputBindings()
    }
    
    /// sets up reactive bindings for view state
    private func setupViewStateBindings() {
        let rateHistoryObservable = makeRateHistoryObservable()
        let ratesObservable = makeRatesObservable()
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
    
    /// sets up reactive bindings for outputs
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
    
    /// makes observable sequence for rate history observable
    ///
    /// - Returns: `Observable<Event<[CurrencyRateHistoryRecord]>>` sequence that emits events for underlying request sequence.
    private func makeRateHistoryObservable() -> Observable<Event<[CurrencyRateHistoryRecord]>> {
        let rateHistoryObservable = viewState
            .filter( { ![.idle, .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<[CurrencyRateHistoryRecord]>>.empty() }
                let rateHistoryObservable = self.fetchRateHistoryUseCase.execute(self.baseCurrency, self.targetCurrency)
                    .materialize()
                return rateHistoryObservable
            }
            .share()
        return rateHistoryObservable
    }
    
    /// makes observable sequence for rate observable
    ///
    /// - Returns: `Observable<Event<[CurrencyRate]>>` sequence that emits events for underlying request sequence.
    private func makeRatesObservable() -> Observable<Event<[CurrencyRate]>> {
        let ratesObservable = viewState
            .filter( { ![.idle, .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<[CurrencyRate]>>.empty() }
                let ratesObservable = self.fetchRatesUseCase.execute(self.baseCurrency, self.targetCurrencies)
                    .materialize()
                return ratesObservable
            }
            .share()
        return ratesObservable
    }
}
