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
        navigationItem.title = "On The Map"
        mapView.delegate = self
        getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(self)
    }
    
    // MARK: MapView delegate methods
    
    // The below code was copied from the PinSample app.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let studentLocation = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: studentLocation)!, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: Actions
    
    @IBAction func logout(_ sender: Any) {
        OnTheMapClient.deleteSession()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
        getStudentLocations()
    }
    
    // MARK: Utility function(s)
    
    func getStudentLocations() {
        
        OnTheMapClient.getStudentLocations { (errorDescription) in
            
            if(errorDescription != nil) {
                self.showFailure(title: "Student Location Data Retrieval Failed", message: errorDescription ?? "Unknown Error")
            }
            
            // The below code was copied from the PinSample app
            // and modified due to updates in the language/project version.
            var annotations = [MKPointAnnotation]()

            for studentLocation in OnTheMapManager.shared.studentLocations {
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
