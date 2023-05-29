//
//  UIViewController+Storyboardable.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import UIKit

extension UIViewController: Storyboardable {
    static func instaintiate(on storyboard: Storyboard) -> Self {
        let vcID = String(describing: self)
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(identifier: vcID) as! Self
    }
}
