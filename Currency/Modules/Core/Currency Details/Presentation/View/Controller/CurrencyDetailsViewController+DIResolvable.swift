//
//  CurrencyDetailsViewController+DIResolvable.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

extension CurrencyDetailsViewController: DIResolvable {
    func resolveDependencies() { }
    func resolveDependencies(baseCurrency: String, targetCurrency: String) {
        let dataSource = DefaultCurrencyDetailsRemoteDataSource(networkManager: .shared)
        let repository = DefaultCurrencyDetailsRepository(dataSource: dataSource)
        let fetchRateHistoryUseCase = DefaultFetchRateHistoryUseCase(repository: repository)
        let fetchRatesUseCase = DefaultFetchRatesUseCase(repository: repository)
        let viewModel = CurrencyDetailsViewModel(baseCurrency: baseCurrency, targetCurrency: targetCurrency, fetchRateHistoryUseCase: fetchRateHistoryUseCase, fetchRatesUseCase: fetchRatesUseCase)
        self.viewModel = viewModel
    }
}
