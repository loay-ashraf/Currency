//
//  AppRoute.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

enum AppRoute: Route {
    case currencyConverter
    case currencyDetails(baseCurrency: String, targetCurrency: String)
}
