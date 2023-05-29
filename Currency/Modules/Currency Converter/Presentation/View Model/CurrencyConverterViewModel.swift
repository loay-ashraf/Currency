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
    // MARK: - Private Properties
    private let fetchSymbolsUseCase: FetchSymbolsUseCase
    private let fetchConversionResultUseCase: FetchConversionResultUseCase
    private let disposeBag = DisposeBag()
    // MARK: - View State
    private(set) var viewState: PublishRelay<CurrencyConverterViewState> = .init()
    // MARK: - Inputs
    private(set) var selectedBaseCurrency: BehaviorRelay<String> = .init(value: Constants.defaultBaseCurrency)
    private(set) var selectedTargetCurrency: BehaviorRelay<String> = .init(value: Constants.defaultTargetCurrency)
    private(set) var baseCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 1.0)
    private(set) var targetCurrencyAmountInput: BehaviorRelay<Double> = .init(value: 0.0)
    // MARK: - Outputs
    private(set) var currencySymbols: Driver<[String]>!
    private(set) var baseCurrencyAmountOutput: Driver<Double>!
    private(set) var targetCurrencyAmountOutput: Driver<Double>!
    private(set) var error: Driver<NetworkError>!
    // MARK: - Initializer
    init(fetchSymbolsUseCase: FetchSymbolsUseCase, fetchConversionResultUseCase: FetchConversionResultUseCase) {
        self.fetchSymbolsUseCase = fetchSymbolsUseCase
        self.fetchConversionResultUseCase = fetchConversionResultUseCase
        setupBindings()
    }
    // MARK: - Instance Methods
    
    /// sets up reacive bindings for view state, inputs and outputs
    private func setupBindings() {
        // Bind View State to Outputs
        setupViewStateBindings()
        // Bind Inputs to View State
        setupInputBindings()
        // Bind Outputs to View State
        setupOutputBindings()
    }
    
    /// sets up reactive bindings for view state
    private func setupViewStateBindings() {
        let symbolsObservable = makeSymbolsObservable()
        let initialBaseConversionResultObservable = makeInitialConversionObservable()
        let baseConversionResultObservable = makeBaseConverionObservable()
        let targetConversionResultObservable = makeTargetConversionObservable()
        let mergedErrorsObservable = Observable.merge([symbolsObservable.compactMap { $0.error as? NetworkError },
                                                        initialBaseConversionResultObservable.compactMap { $0.error as? NetworkError },
                                                        baseConversionResultObservable.compactMap { $0.error as? NetworkError },
                                                        targetConversionResultObservable.compactMap { $0.error as? NetworkError }])
        currencySymbols = symbolsObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        baseCurrencyAmountOutput = targetConversionResultObservable
            .compactMap({ $0.element })
            .asDriver(onErrorJustReturn: 0.0)
        targetCurrencyAmountOutput = Observable.merge([initialBaseConversionResultObservable, baseConversionResultObservable])
            .compactMap({ $0.element })
            .asDriver(onErrorJustReturn: 0.0)
        error = mergedErrorsObservable
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
    }
    
    /// sets up reactive bindings for inputs
    private func setupInputBindings() {
        selectedBaseCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .baseConversion) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        selectedTargetCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .baseConversion) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        baseCurrencyAmountInput
            .asObservable()
            .map({ _ in .loading(loadType: .baseConversion) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        targetCurrencyAmountInput
            .asObservable()
            .map({ _ in .loading(loadType: .targetConversion) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
    
    /// sets up reactive bindings for outputs
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
    
    /// makes observable sequence for available currency symbols
    ///
    /// - Returns: `Observable<Event<Double>>` sequence that emits events for underlying request sequence.
    private func makeSymbolsObservable() -> Observable<Event<[String]>> {
        let symbolsObservable = viewState
            .filter( { ![.idle, .loading(loadType: .baseConversion), .loading(loadType: .targetConversion), .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<[String]>>.empty() }
                let conversionResultObservable = self.fetchSymbolsUseCase.execute()
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        return symbolsObservable
    }
    
    /// makes observable sequence for initial conversion of default currencies ("EUR, ->"USD"")
    ///
    /// - Returns: `Observable<Event<Double>>` sequence that emits events for underlying request sequence.
    private func makeInitialConversionObservable() -> Observable<Event<Double>> {
        let initialBaseConversionResultObservable = viewState
            .filter( { ![.idle, .loading(loadType: .baseConversion), .loading(loadType: .targetConversion), .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<Double>>.empty() }
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
        return initialBaseConversionResultObservable
    }
    
    /// makes observable sequence for base conversion
    ///
    /// - Returns: `Observable<Event<Double>>` sequence that emits events for underlying request sequence.
    private func makeBaseConverionObservable() -> Observable<Event<Double>> {
        let baseConversionResultObservable = viewState
            .debounce(.milliseconds(100), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .filter( { ![.idle, .loading(loadType: .initial), .loading(loadType: .targetConversion), .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<Double>>.empty() }
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
        return baseConversionResultObservable
    }
    
    /// makes observable sequence for target based conversion
    ///
    /// - Returns: `Observable<Event<Double>>` sequence that emits events for underlying request sequence.
    private func makeTargetConversionObservable() -> Observable<Event<Double>> {
        let targetConversionResultObservable = viewState
            .debounce(.milliseconds(100), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .filter( { ![.idle, .loading(loadType: .initial), .loading(loadType: .baseConversion), .error].contains($0) })
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Event<Double>>.empty() }
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
        return targetConversionResultObservable
    }
}
