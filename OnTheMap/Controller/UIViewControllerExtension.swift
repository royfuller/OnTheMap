//
//  UIViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 10/19/20.
//

import UIKit

extension UIViewController {
    func showFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false, completion: nil)
    }
}
