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
        OnTheMapClient.createSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleCreateSessionResponse(createSessionResponse:error:))
    }

    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    // MARK: Utility function(s)

    func handleCreateSessionResponse(createSessionResponse: CreateSessionResponse?, error: Error?) {
        if error != nil {
            print(error!) // How to handle error here?
        } else {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
}

