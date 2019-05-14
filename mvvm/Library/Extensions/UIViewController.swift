//
//  UIViewController.swift
//  mvvm
//
//  Created by Ivan Smetanin on 15/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(error: Error) {
        let alertController = UIAlertController(
            title: L10n.Alerts.Error.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: L10n.Alerts.Error.cancelActionTitle,
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

}
