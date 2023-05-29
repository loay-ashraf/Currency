//
//  CurrencyConverterViewState.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

enum CurrencyConverterViewState: Equatable {
    case idle
    case loading(loadType: CurrencyConverterViewLoadType)
    case error
}
