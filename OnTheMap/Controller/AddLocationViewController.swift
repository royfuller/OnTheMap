//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Roy Fuller on 9/24/20.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Variables
    
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    let latDelta:CLLocationDegrees = 0.05
    let lonDelta:CLLocationDegrees = 0.05
    var studentLocation: StudentLocation!
    let unknownError = "Unknown Error"
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Location"
        mapView.delegate = self
        placePinAndZoomRegion()
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
    
    func placePinAndZoomRegion() {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let firstName = studentLocation.firstName
        let lastName =  studentLocation.lastName
        let span = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = studentLocation.mediaURL
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: false)
    }
}
