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
    private let fetchRateHistoryUseCase: FetchRateHistoryUseCase
    private let disposeBag = DisposeBag()
    // MARK: - View State
    private(set) var viewState: PublishRelay<CurrencyConverterViewState> = .init()
//    // MARK: - Inputs
//    private(set) var selectedBaseCurrency: BehaviorRelay<String> = .init(value: "EUR")
//    private(set) var selectedTargetCurrency: BehaviorRelay<String> = .init(value: "USD")
//    private(set) var baseCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 1.0)
//    private(set) var targetCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 0.0)
    // MARK: - Outputs
    private(set) var rateHistory: Driver<[CurrencyRateHistoryRecord]>!
    private(set) var baseCurrencyAmountOutput: Driver<Double>!
    private(set) var targetCurrencyAmountOutput: Driver<Double>!
    private(set) var error: Driver<NetworkError>!
    init(baseCurrency: String, targetCurrency: String, fetchRateHistoryUseCase: FetchRateHistoryUseCase) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.fetchRateHistoryUseCase = fetchRateHistoryUseCase
        setupBindings()
    }
    private func setupBindings() {
        // Bind View State to Outputs
        setupViewStateBindings()
        // Bind Inputs to View State
//        setupInputBindings()
        // Bind Outputs to View State
        setupOutputBindings()
    }
    private func setupViewStateBindings() {
        let rateHistoryObservable = setupSymbolsObservable()
        let mergedErrorsObservable = Observable.merge([rateHistoryObservable.compactMap { $0.error as? NetworkError }])
        rateHistory = rateHistoryObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        error = mergedErrorsObservable
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
    }
    private func setupSymbolsObservable() -> Observable<Event<[CurrencyRateHistoryRecord]>> {
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
//    private func setupInputBindings() {
//        selectedBaseCurrency
//            .asObservable()
//            .map({ _ in .loading(loadType: .baseDriven) })
//            .bind(to: viewState)
//            .disposed(by: disposeBag)
//        selectedTargetCurrency
//            .asObservable()
//            .map({ _ in .loading(loadType: .baseDriven) })
//            .bind(to: viewState)
//            .disposed(by: disposeBag)
//        baseCurrencyAmountInput
//            .asObservable()
//            .map({ _ in .loading(loadType: .baseDriven) })
//            .bind(to: viewState)
//            .disposed(by: disposeBag)
//        targetCurrencyAmountInput
//            .asObservable()
//            .map({ _ in .loading(loadType: .targetDriven) })
//            .bind(to: viewState)
//            .disposed(by: disposeBag)
//    }
    private func setupOutputBindings() {
        rateHistory
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
