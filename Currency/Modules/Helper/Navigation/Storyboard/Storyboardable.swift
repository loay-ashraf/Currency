//
//  Storyboardable.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import Foundation
import UIKit

protocol Storyboardable: UIViewController {
    static func instaintiate(on storyboard: Storyboard) -> Self
}
