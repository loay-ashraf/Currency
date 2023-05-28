//
//  UIView+SetRadiusAndShadow.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import UIKit

extension UIView {
    func setRadiusAndShadow() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
}
