//
//  CurrencyDetailsRepository.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import RxSwift

protocol CurrencyDetailsRepository {
    func fectchRateHistory(_ base: String, _ target: String) -> Observable<[Double]>
}
