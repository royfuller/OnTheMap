//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/22/20.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Variables
    var studentLocations = [StudentLocation]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "On The Map"
        getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationsTableViewCell")!
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = "\(studentLocation.mediaURL)"
        //cell.imageView?.image = UIImage(named: "Map_pin")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentLocations[(indexPath as NSIndexPath).row]
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
    
    // MARK: Utility function(s)
    
    func getStudentLocations() {
        OnTheMapClient.getStudentLocations { (studentLocations, error) in
            if error != nil {
                // Handle error - popup maybe?
            } else {
                self.studentLocations = studentLocations
            }
            self.tableView.reloadData()
        }
    }
}
