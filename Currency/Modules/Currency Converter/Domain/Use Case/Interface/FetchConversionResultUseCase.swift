//
//  FetchConversionResultUseCase.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

protocol FetchConversionResultUseCase {
    associatedtype ReturnType
    func execute(_ base: String, _ target: String, _ amount: Double) -> ReturnType
}
