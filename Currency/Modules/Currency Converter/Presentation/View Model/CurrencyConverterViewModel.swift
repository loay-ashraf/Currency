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
    private(set) var selectedBaseCurrency: BehaviorRelay<String> = .init(value: "")
    private(set) var selectedTargetCurrency: BehaviorRelay<String> = .init(value: "")
    private(set) var baseCurrencyAmount: BehaviorRelay<Double> = .init(value: 0.0)
    // MARK: - Outputs
    private(set) var currencySymbols: Driver<[String]>!
    private(set) var targetCurrencyAmount: Driver<Double>!
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
            .filter( { ![.idle, .loading(loadType: .normal), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchSymbolsUseCase.execute()
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let conversionResultObservable = viewState
            .filter( { ![.idle, .loading(loadType: .initial), .loading(loadType: .refresh), .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest { _ in
                let conversionResultObservable = self.fetchConversionResultUseCase.execute(self.selectedBaseCurrency.value,
                                                                                           self.selectedTargetCurrency.value,
                                                                                           self.baseCurrencyAmount.value)
                    .map {
                        $0.value
                    }
                    .materialize()
                return conversionResultObservable
            }
            .share()
        let mergedOutputsObservable = Observable.merge([currencySymbolsObservable.map { $0 as AnyObject },
                                                        conversionResultObservable.map { $0 as AnyObject }])
        currencySymbols = currencySymbolsObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        targetCurrencyAmount = conversionResultObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: 0.0)
        error = mergedOutputsObservable
            .compactMap { $0.error as? NetworkError }
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
    }
    private func setupInputBindings() {
        selectedBaseCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .normal) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        selectedTargetCurrency
            .asObservable()
            .map({ _ in .loading(loadType: .normal) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        baseCurrencyAmount
            .asObservable()
            .map({ _ in .loading(loadType: .normal) })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
    private func setupOutputBindings() {
        currencySymbols
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        targetCurrencyAmount
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
