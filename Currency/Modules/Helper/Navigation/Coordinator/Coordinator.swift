//
//  Coordinator.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import Foundation

protocol Coordinator {
    associatedtype R: Route
    func trigger(_ route: R)
}
