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
    var latitude: Double!
    var longitude: Double!
    var annotations = [MKPointAnnotation]()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Location"
        mapView.delegate = self
        geocodeLocation()
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
        OnTheMapClient.createStudentLocation(studentLocation: OnTheMapManager.shared.studentLocation) { (createStudentLocationResponse, error) in
            if(error != nil) {
                print(error!) // TODO: How to handle error here?
                return
            }
            let controller: UITabBarController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: Utility function(s)
    
    // The below code was adapted from https://cocoacasts.com/forward-geocoding-with-clgeocoder
    func geocodeLocation() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            guard let placemarks = placemarks else {
                print(error!)  // TODO: How to handle error here?
                return
            }
                
            // TODO: How to handle unwrapping here?
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
            
            // TODO: Move this code to finish and fix update logic.
            if OnTheMapManager.shared.studentLocation == nil {
                OnTheMapManager.shared.studentLocation = StudentLocation(firstName: firstName, lastName: lastName, latitude: latitude!, longitude: longitude!, mapString: self.location, mediaURL: self.mediaURL, uniqueKey: OnTheMapManager.shared.userId, objectId: nil, createdAt: nil, updatedAt: nil)
            } else {
                OnTheMapManager.shared.studentLocation.latitude = latitude!
                OnTheMapManager.shared.studentLocation.longitude = longitude!
                OnTheMapManager.shared.studentLocation.mapString = self.location
                OnTheMapManager.shared.studentLocation.mediaURL = self.mediaURL
            }
            
            // TODO: I don't like this - how should I create StudentLocation?
            DispatchQueue.main.async {
                self.annotations.append(annotation)
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
}
