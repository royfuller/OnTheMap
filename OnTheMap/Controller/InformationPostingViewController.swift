//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/24/20.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    // MARK: Variables
    let geocoder = CLGeocoder()
    let unknownError = "Unknown Error"
    var studentLocation: StudentLocation!
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        setFindingLocation(findingLocation: true)
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            guard let placemarks = placemarks else {
                DispatchQueue.main.async {
                    self.setFindingLocation(findingLocation: false)
                    self.showFailure(title: "Address Geocoding Failed", message: error?.localizedDescription ?? self.unknownError)
                }
                return
            }
                
            let location = placemarks.first?.location
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude
            let mediaURL = self.linkTextField.text!
            let firstName = OnTheMapManager.shared.publicUserData.firstName
            let lastName =  OnTheMapManager.shared.publicUserData.lastName
            
            DispatchQueue.main.async {
                self.studentLocation = StudentLocation(firstName: firstName, lastName: lastName, latitude: latitude!, longitude: longitude!, mapString: self.locationTextField.text!, mediaURL: mediaURL, uniqueKey: OnTheMapManager.shared.userId, objectId: nil, createdAt: nil, updatedAt: nil)
                self.latitude = latitude
                self.longitude = longitude
                
                self.setFindingLocation(findingLocation: false)
                self.performSegue(withIdentifier: "addLocation", sender: self)
            }
        }
    }
    
    func setFindingLocation(findingLocation: Bool) {
        if findingLocation {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! AddLocationViewController
        controller.studentLocation = studentLocation
        controller.latitude = latitude
        controller.longitude = longitude
    }
}
