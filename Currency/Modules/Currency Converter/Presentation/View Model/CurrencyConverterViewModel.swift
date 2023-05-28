//
//  CurrencyConverterViewModel.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyConverterViewModel {
    private let fetchSymbolsUseCase: FetchSymbolsUseCase
    private let fetchConversionResultUseCase: FetchConversionResultUseCase
    private let disposeBag = DisposeBag()
    // MARK: - View State
    private(set) var viewState: PublishRelay<ViewState> = .init()
    // MARK: - Inputs
    private(set) var selectedBaseCurrency: BehaviorRelay<String> = .init(value: "EUR")
    private(set) var selectedTargetCurrency: BehaviorRelay<String> = .init(value: "USD")
    private(set) var baseCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 1.0)
    private(set) var targetCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 0.0)
    // MARK: - Outputs
    private(set) var currencySymbols: Driver<[String]>!
    private(set) var baseCurrencyAmountOutput: Driver<Double>!
    private(set) var targetCurrencyAmountOutput: Driver<Double>!
    private(set) var error: Driver<NetworkError>!
    init(fetchSymbolsUseCase: FetchSymbolsUseCase, fetchConversionResultUseCase: FetchConversionResultUseCase) {
        self.fetchSymbolsUseCase = fetchSymbolsUseCase
        self.fetchConversionResultUseCase = fetchConversionResultUseCase
        setupBindings()
    }
    private func setupBindings() {
        // Bind View State to Outputs
        setupViewStateBindings()
        // Bind Inputs to View State
        setupInputBindings()
        // Bind Outputs to View State
        setupOutputBindings()
    }
    private func setupViewStateBindings() {
        let currencySymbolsObservable = viewState
            .filter( { ![.idle, .loading(loadType: .baseDriven), .loading(loadType: .targetDriven), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchSymbolsUseCase.execute()
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let initialBaseConversionResultObservable = viewState
            .filter( { ![.idle, .loading(loadType: .baseDriven), .loading(loadType: .targetDriven), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchConversionResultUseCase.execute(self.selectedBaseCurrency.value,
                                                                                           self.selectedTargetCurrency.value,
                                                                                           self.baseCurrencyAmountInput.value)
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let baseConversionResultObservable = viewState
            .debounce(.milliseconds(100), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .filter( { ![.idle, .loading(loadType: .initial), .loading(loadType: .targetDriven), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchConversionResultUseCase.execute(self.selectedBaseCurrency.value,
                                                                                           self.selectedTargetCurrency.value,
                                                                                           self.baseCurrencyAmountInput.value)
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let targetConversionResultObservable = viewState
            .debounce(.milliseconds(100), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .filter( { ![.idle, .loading(loadType: .initial), .loading(loadType: .baseDriven), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchConversionResultUseCase.execute(self.selectedTargetCurrency.value,
                                                                                           self.selectedBaseCurrency.value,
                                                                                           self.targetCurrencyAmountInput.value)
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let mergedOutputsObservable = Observable.merge([currencySymbolsObservable.map { $0 as AnyObject },
                                                        initialBaseConversionResultObservable.map { $0 as AnyObject },
                                                        baseConversionResultObservable.map { $0 as AnyObject },
                                                        targetConversionResultObservable.map { $0 as AnyObject }])
        currencySymbols = currencySymbolsObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        baseCurrencyAmountOutput = targetConversionResultObservable
            .compactMap({ $0.element })
            .asDriver(onErrorJustReturn: 0.0)
        targetCurrencyAmountOutput = Observable.merge([initialBaseConversionResultObservable, baseConversionResultObservable])
            .compactMap({ $0.element })
            .asDriver(onErrorJustReturn: 0.0)
        error = mergedOutputsObservable
            .compactMap { $0.error as? NetworkError }
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
    }
    private func setupInputBindings() {
        selectedBaseCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .baseDriven) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        selectedTargetCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .baseDriven) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        baseCurrencyAmountInput
            .asObservable()
            .map({ _ in .loading(loadType: .baseDriven) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        targetCurrencyAmountInput
            .asObservable()
            .map({ _ in .loading(loadType: .targetDriven) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
    private func setupOutputBindings() {
        currencySymbols
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        baseCurrencyAmountOutput
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        targetCurrencyAmountOutput
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