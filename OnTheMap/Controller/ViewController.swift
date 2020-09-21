//
//  ViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/21/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getStudents(_ sender: Any) {
        OnTheMapClient.getStudentLocations()
    }
    
}

