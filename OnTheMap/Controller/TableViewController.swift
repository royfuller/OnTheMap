//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/22/20.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Lifecycle
    
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "On The Map"
        OnTheMapClient.getStudentLocations { (studentLocations, error) in
            if error != nil {
                // Handle error - popup maybe?
            } else {
                self.studentLocations = studentLocations
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
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
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: MemeConstants.memeDetailViewController) as! MemeDetailViewController
//        detailController.meme = MemesManager.shared.getMemes()[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//    }
}
