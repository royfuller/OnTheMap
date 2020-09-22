//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        OnTheMapClient.createSession(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func deleteSession(_ sender: Any) {
        OnTheMapClient.deleteSession()
    }
    
    @IBAction func getStudents(_ sender: Any) {
        OnTheMapClient.getStudentLocations()
    }
    
}

