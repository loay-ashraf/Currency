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
    // MARK: - Static Properties
    static let shared = NetworkManager()
    // MARK: - Initializer
    private init() {}
    // MARK: - Instance Methods
    
    /// performs HTTP request.
    ///
    /// - Parameter router: router object that contains request details
    ///
    /// - Returns: generic `Observable` sequence that emits decoded response or an error.
    func request<T: Decodable>(using router: NetworkRouter) -> Observable<T> {
        let request = router.asURLRequest()
        dump(request)
        let responseObservable = URLSession.shared.rx.response(request: request)
            .catch {
                throw NetworkError.client(.transport($0))
            }
            .map { response, data in
                guard let networkError = NetworkError(response) else {
                    let jsonDecoder = JSONDecoder()
                    do {
                        print(data.prettyPrintedJSONString!)
                        let model = try jsonDecoder.decode(T.self, from: data)
                        dump(model)
                        return model
                    } catch {
                        if let errorModel = try? jsonDecoder.decode(DefaultNetworkAPIError.self, from: data) {
                            throw errorModel
                        } else {
                            throw NetworkError.client(.serialization(error))
                        }
                    }
                }
                throw networkError
            }
        return responseObservable
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
