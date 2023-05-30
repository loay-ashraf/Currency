//
//  CurrencyConverterViewController+DIResolvable.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

extension CurrencyConverterViewController: DIResolvable {
    func resolveDependencies() {
        let dataSource = DefaultCurrencyConverterRemoteDataSource(networkManager: .shared)
        let repository = DefaultCurrencyConverterRepository(dataSource: dataSource)
        let fetchSymbolsUseCase = DefaultFetchSymbolsUseCase(repository: repository)
        let fetchConversionResultUseCase = DefaultFetchConversionResultUseCase(repository: repository)
        let viewModel = CurrencyConverterViewModel(fetchSymbolsUseCase: fetchSymbolsUseCase, fetchConversionResultUseCase: fetchConversionResultUseCase)
        self.viewModel = viewModel
    }
}
