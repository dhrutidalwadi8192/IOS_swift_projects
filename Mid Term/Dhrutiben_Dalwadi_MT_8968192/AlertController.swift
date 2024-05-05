import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                completion?()
            }
        )

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
