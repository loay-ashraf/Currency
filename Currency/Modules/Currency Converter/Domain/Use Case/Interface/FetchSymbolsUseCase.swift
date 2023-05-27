//
//  FetchSymbolsUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

protocol FetchSymbolsUseCase {
    associatedtype ReturnType
    func execute() -> ReturnType
}
