//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/22/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "On The Map"
        getStudentLocations()
    }
    
    // MARK: MKMapViewDelegate
    

    // The below code was copied from the PinSample app.
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
    
    @IBAction func logout(_ sender: Any) {
        OnTheMapClient.deleteSession()
        let controller: LoginViewController
        controller = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        getStudentLocations()
    }
    
    // MARK: Utility function(s)
    
    func getStudentLocations() {
        OnTheMapClient.getStudentLocations { (studentLocations, error) in
            
            // The below code was copied from the PinSample app
            // and modified due to updates in the language/project version.
            var annotations = [MKPointAnnotation]()

            for studentLocation in studentLocations {
                let lat = CLLocationDegrees(studentLocation.latitude)
                let long = CLLocationDegrees(studentLocation.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = studentLocation.firstName
                let lastName = studentLocation.lastName
                let mediaURL = studentLocation.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
}
