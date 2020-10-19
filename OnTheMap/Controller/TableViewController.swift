//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/22/20.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "On The Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    
    // MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapManager.shared.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationsTableViewCell")!
        let studentLocation = OnTheMapManager.shared.studentLocations[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = "\(studentLocation.mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = OnTheMapManager.shared.studentLocations[(indexPath as NSIndexPath).row]
        UIApplication.shared.open(URL(string: studentLocation.mediaURL)!, options: [:], completionHandler: nil)
    }
    
    // MARK: Actions
    
    @IBAction func logout(_ sender: Any) {
        OnTheMapClient.deleteSession()
        let controller: LoginViewController
        controller = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        getStudentLocations()
    }
    
    // MARK: Utility functions
    
    func getStudentLocations() {
        OnTheMapClient.getStudentLocations { (errorDescription) in
            if errorDescription != nil {
                self.showLoginFailure(message: errorDescription ?? "Unknown Error")
            }
            self.tableView.reloadData()
        }
    }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Student Location Data Retrieval Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false, completion: nil)
    }
}
