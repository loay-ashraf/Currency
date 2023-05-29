//
//  CurrencyDetailsViewState.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

enum CurrencyDetailsViewState: Equatable {
    case idle
    case loading(loadType: CurrencyDetailsViewLoadType)
    case error
}
