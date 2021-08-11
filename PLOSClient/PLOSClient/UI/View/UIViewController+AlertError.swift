//
//  ViewController+AlertError.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import UIKit

extension UIViewController {
    public func presentAlertError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
