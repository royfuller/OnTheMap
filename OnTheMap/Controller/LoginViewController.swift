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
        // TODO: Perhaps check for empty string?
        OnTheMapClient.createSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleCreateSessionResponse(userId:error:))
    }

    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    // MARK: Utility function(s)

    func handleCreateSessionResponse(userId: String?, error: Error?) {
        guard let userId = userId else {
            print(error!)  // TODO: Error handling
            return
        }
        OnTheMapManager.shared.userId = userId
        OnTheMapClient.getPublicUserData(userId: userId, completionHandler: handleGetPublicUserDataResponse(publicUserDataResonse:error:))
    }
    
    func handleGetPublicUserDataResponse(publicUserDataResonse: GetPublicUserDataResponse?, error: Error?) {
        guard let publicUserDataResponse = publicUserDataResonse else {
            print(error!)
            return
        }
        OnTheMapManager.shared.publicUserData = publicUserDataResponse
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
}

