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
    var annotations = [MKPointAnnotation]()
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Location"
        
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
            
            // TODO: Get student name from Udactiy API
//            let firstName = studentLocation.firstName
//            let lastName = studentLocation.lastName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
//            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = self.mediaURL
            
            DispatchQueue.main.async {
                self.annotations.append(annotation)
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
    
    // MARK: Utility function(s)
    
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
}
