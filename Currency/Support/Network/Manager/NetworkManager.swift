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
        dump(request)
        let responseObservable = URLSession.shared.rx.response(request: request)
            .catch {
                throw NetworkError.client(.transport($0))
            }
            .map { response, data in
                guard let networkError = NetworkError(response) else {
                    let jsonDecoder = JSONDecoder()
                    print(data.prettyPrintedJSONString!)
                    let model = try jsonDecoder.decode(T.self, from: data)
                    dump(model)
                    return model
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
