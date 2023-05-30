//
//  AppCoordinator.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    var navigationController: UINavigationController
    // MARK: - Initiailizer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    // MARK: - Instance Methods
    
    /// triggers navigation action to a specific route
    /// 
    /// - Parameter route: `Route` to be navigated to
    func trigger(_ route: AppRoute) {
        switch route {
        case .currencyConverter:
            let viewController = CurrencyConverterViewController.instaintiate(on: .currencyConverter)
            viewController.resolveDependencies()
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        case .currencyDetails(let baseCurrency, let targetCurrency):
            let viewController = CurrencyDetailsViewController.instaintiate(on: .currenyDetails)
            viewController.resolveDependencies(baseCurrency: baseCurrency, targetCurrency: targetCurrency)
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
