//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions

    @IBAction func login(_ sender: Any) {
        OnTheMapClient.createSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleCreateSessionResponse(userId:errorDescription:))
    }

    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }

    // MARK: Utility function(s)

    func handleCreateSessionResponse(userId: String?, errorDescription: String?) {
        guard let userId = userId else {
            showLoginFailure(message: errorDescription ?? "Unknown error")
            return
        }
        OnTheMapManager.shared.userId = userId
        OnTheMapClient.getPublicUserData(userId: userId, completionHandler: handleGetPublicUserDataResponse(publicUserDataResonse:error:))
    }
    
    func handleGetPublicUserDataResponse(publicUserDataResonse: GetPublicUserDataResponse?, error: Error?) {
        guard let publicUserDataResponse = publicUserDataResonse else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            return
        }
        OnTheMapManager.shared.publicUserData = publicUserDataResponse
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

