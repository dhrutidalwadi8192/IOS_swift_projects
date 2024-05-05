//
//  AlertController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit

// Alert Extension
extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        // alert message
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        // action button
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                completion?()
            }
        )
        
        alertController.addAction(okAction)

        // display alert
        present(alertController, animated: true, completion: nil)
    }
}


