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
    // connect to the map view
    @IBOutlet weak var map: MKMapView!
    
    // database connection
    var db = Firestore.firestore()
    
    // provide map functionality
    var locationManager = CLLocationManager()
    
    // get all addresses, current user ID, and current user address
    var addresses = [String]()
    var userID: String!
    var address = ""
    
    // convert addresses to latitude and longitude
    let geocoder = CLGeocoder()
    let regionRadius: CLLocationDistance = 2414.02
    let annotation = MKPointAnnotation()
    
    // center map on the location given
    func centerMapOnLocation(location: CLLocation) {
        // constraints to restrict user to nearby area
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard function used in all files
        self.hideKeyboardWhenTappedAround()
        
        // set up the map
        map.delegate = self
        map.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        // get current user's address
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            userID = user.uid
            // find the current user in the db
            db.collection("users").whereField("userID", isEqualTo: userUID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        // error trapping for not being able to get documents
                        print("Error getting documents from authenticated user: \(error)")
                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        for document in querySnapshot!.documents {
                            let docData = document.data()
                            // get the current address
                            self.address = (docData["address"] as! String)
                            let geoCoder = CLGeocoder()
                            // get the latitude and longitude for an address
                            geoCoder.geocodeAddressString(self.address) { (placemarks, error) in
                                guard
                                    let placemarks = placemarks,
                                    let location = placemarks.first?.location
                                    else {
                                        // handle no location found
                                        return
                                }
                                self.centerMapOnLocation(location: location)
                            }
                            // get all addresses except for current user's
                            self.db.collection("users").getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    // use db query inside of another db query to handle asynchronous processing
                                    for document in querySnapshot!.documents {
                                        let docData = document.data()
                                        let add = docData["address"] as! String
                                        // if the address doesn't belong to the user then add it to the array
                                        if add != self.address {
                                            self.addresses.append(add)
                                        }
                                    }
                                    // for each location in the addresses, create a map pin
                                    for location in self.addresses {
                                        let ann = MKPointAnnotation()
                                        // split the address for the map annotation
                                        var fullLocationArr = location.split{$0 == ","}.map(String.init)
                                        ann.title = fullLocationArr[0]
                                        let halfAdd = fullLocationArr[1] + "," + fullLocationArr[2]
                                        let trimmedString = halfAdd.trimmingCharacters(in: .whitespacesAndNewlines)
                                        ann.subtitle = trimmedString
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
                        }
                    }
            }
        } else {
            print("Unable to validate user and query their gear")
        }
        
        map.showsUserLocation = true
        //        centerMapOnLocation(location: location)
    }
    
    // segue when you tap on the button for the pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let current = view.annotation!.title!! + ", " + view.annotation!.subtitle!!
            if current != address {
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = Storyboard.instantiateViewController(withIdentifier: "AvaliableProducts") as! TableViewController
                db.collection("items").whereField("address", isEqualTo: current).getDocuments() { (querySnapshot, err) in
                    print("All Documents")
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docData = document.data()
                            let itemName = docData["item_name"] as! String
                            vc.products.append(itemName)
                            print(itemName)
                            let priceStr = docData["price_per_day"] as! String
                            print(priceStr)
                            vc.prices.append("$" + priceStr)
                            let conditionStr = docData["item_condition"] as! String
                            print(conditionStr)
                            vc.condition.append(conditionStr)
                            let uid = docData["owner_UID"] as! String
                            let documentName = "\(String(describing: uid))-\(String(describing: itemName))"
                            vc.documents.append(documentName)
                            print(documentName)
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            print("map pin clicked")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let smallRect = CGSize(width: 122, height: 22)
            let rightButton = UIButton(frame: CGRect(origin: .zero, size: smallRect))
            rightButton.tag = annotation.hash
            rightButton.backgroundColor = UIColor(hue: 0.55, saturation: 1, brightness: 0.89, alpha: 1.0)
            rightButton.layer.cornerRadius = 5
            rightButton.layer.borderWidth = 1
            rightButton.layer.borderColor = UIColor.black.cgColor
            let label = UILabel(frame: CGRect(x: -40, y: 3, width: 200, height: 15))
            label.textAlignment = .center
            label.text = "View Products"
            label.textColor = .white
            rightButton.addSubview(label)
            
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


