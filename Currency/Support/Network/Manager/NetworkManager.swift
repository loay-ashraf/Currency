//
//  NetworkManager.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func request<T: Decodable>(using router: NetworkRouter) -> Observable<T> {
        let request = router.asURLRequest()
        let responseObservable = URLSession.shared.rx.response(request: request)
            .map { response, data in
                guard let networkError = NetworkError(response) else {
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(T.self, from: data)
                    return model
                }
                throw networkError
            }
        return responseObservable
    }
}
