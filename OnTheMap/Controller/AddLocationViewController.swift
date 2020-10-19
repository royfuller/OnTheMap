//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/24/20.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Variables
    
    var location: String!
    var mediaURL: String!
    var studentLocation: StudentLocation!
    var annotations = [MKPointAnnotation]()
    let unknownError = "Unknown Error"
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Location"
        mapView.delegate = self
        setFindingLocation(findingLocation: true, finishEnabled: false)
        geocodeLocation()
        setFindingLocation(findingLocation: false, finishEnabled: true)
    }

    // MARK: MapView delegate methods
    
    // The below code was copied from the PinSample app. - Should this be broken out into it's own delegate class?
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)//.detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: Actions
    
    @IBAction func finish(_ sender: Any) {
        if OnTheMapManager.shared.objectId == nil {
            OnTheMapClient.createStudentLocation(studentLocation: studentLocation) { (error) in
                if(error != nil) {
                    self.showFailure(title: "Failure Creating Student Location", message: error?.localizedDescription ?? self.unknownError)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            OnTheMapClient.updateStudentLocation(objectId: OnTheMapManager.shared.objectId, newStudentLocation: studentLocation) { (error) in
                if(error != nil) {
                    self.showFailure(title: "Failure Updating Student Location", message: error?.localizedDescription ?? self.unknownError)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Utility function(s)
    
    // The below code was adapted from https://cocoacasts.com/forward-geocoding-with-clgeocoder
    func geocodeLocation() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            guard let placemarks = placemarks else {
                DispatchQueue.main.async {
                    self.setFindingLocation(findingLocation: false, finishEnabled: false)
                    self.showFailure(title: "Address Geocoding Failed", message: error?.localizedDescription ?? self.unknownError)
                }
                return
            }
                
            let location = placemarks.first?.location
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude
            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            
            let firstName = OnTheMapManager.shared.publicUserData.firstName
            let lastName =  OnTheMapManager.shared.publicUserData.lastName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = self.mediaURL
            
            DispatchQueue.main.async {
                self.annotations.append(annotation)
                self.mapView.addAnnotations(self.annotations)
                self.studentLocation = StudentLocation(firstName: firstName, lastName: lastName, latitude: latitude!, longitude: longitude!, mapString: self.location, mediaURL: self.mediaURL, uniqueKey: OnTheMapManager.shared.userId, objectId: nil, createdAt: nil, updatedAt: nil)
            }
        }
    }
    
    func setFindingLocation(findingLocation: Bool, finishEnabled: Bool) {
        if findingLocation {
            activityIndicator.startAnimating()
            finishButton.isEnabled = finishEnabled
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            finishButton.isEnabled = finishEnabled
        }
    }
}
