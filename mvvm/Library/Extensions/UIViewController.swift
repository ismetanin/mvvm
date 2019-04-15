//
//  UIViewController.swift
//  mvvm
//
//  Created by Ivan Smetanin on 15/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

extension UIViewController {

    @discardableResult
    func showAlert(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        return alertController
    }

    @discardableResult
    func showAlert(error: Error) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Error!",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        return alertController
    }

}
