//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        OnTheMapClient.createSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleCreateSessionResponse(createSessionResponse:error:))
    }
    
    func handleCreateSessionResponse(createSessionResponse: CreateSessionResponse?, error: Error?) {
        if error != nil {
            print(error!) // How to handle error here?
        } else {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
}

