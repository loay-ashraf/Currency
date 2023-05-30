//
//  UIViewController+presentError.swift
//  Currency
//
//  Created by Loay Ashraf on 30/05/2023.
//

import UIKit

extension UIViewController {
    func presentError(_ error: NetworkError) {
        var message = ""
        if case .client(.notConnected) = error {
            message = "You are not connected to the internet."
        } else {
            message = "An error occured.\n\(error.localizedDescription)"
        }
        let alertController = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}
