//
//  NetworkRouter.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import Foundation

protocol NetworkRouter {
    var scheme: HTTPScheme { get }
    var method: HTTPMethod { get }
    var domain: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String]? { get }
    var body: [String: Any]? { get }
    var url: URL? { get }
    /// Creates `URLRequest` object using router properties.
    ///
    /// - Returns: `URLRequest` created using router properties.
    func asURLRequest() -> URLRequest
}
