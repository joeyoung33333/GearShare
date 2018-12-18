//
//  MapViewController.swift
//  GearShare
//
//  Created by Larry Liu on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var db = Firestore.firestore()
    var locationManager = CLLocationManager()
    var addresses = [String]()
    var userID: String!
    var address = ""
    
    let geocoder = CLGeocoder()
    let regionRadius: CLLocationDistance = 2414.02
    let annotation = MKPointAnnotation()
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        // get all addresses except for current user's
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    let add = docData["address"] as! String
                    if add != self.address {
                        self.addresses.append(add)
                        print(add)
                    }
                }
                for location in self.addresses {
                    let ann = MKPointAnnotation()
                    ann.title = location
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(location) { (placemarks, error) in
                        guard
                            let placemarks = placemarks,
                            let location = placemarks.first?.location
                            else {
                                // handle no location found
                                return
                        }
                        ann.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        self.map.addAnnotation(ann)
                    }
                }
                
            }
        }
        
        // get current user's address
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            userID = user.uid
            db.collection("users").whereField("userID", isEqualTo: userUID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents from authenticated user: \(error)")
                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        for document in querySnapshot!.documents {
                            let docData = document.data()
                            self.address = (docData["address"] as! String)
                            print(self.address)
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(self.address) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else {
                                        // handle no location found
                                        return
                                }
                                
                                self.centerMapOnLocation(location: location)
                                self.annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                                self.annotation.title = "Current Location"
                                self.map.addAnnotation(self.annotation)
                            }
                        }
                    }
            }
        } else {
            print("Unable to validate user and query their gear")
        }
        
        map.showsUserLocation = true
        //        centerMapOnLocation(location: location)
    }
    
    // When user taps on the disclosure button you can perform a segue to navigate to another view controller
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("go to bed")
            
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))

            let rightButton = UIButton(type: .contactAdd)
            rightButton.tag = annotation.hash

            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton

            return pinView
        }
        else {
            return nil
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = map.userLocation.coordinate
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


