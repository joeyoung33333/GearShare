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
                        // alert for the error
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        // present the alert controller if there's an error
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
                                // center the map on the user's address
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
                                        ann.title = location
                                        // split the address for the map annotation
//                                        var fullLocationArr = location.split{$0 == ","}.map(String.init)
                                        // the title will be the number and street address
//                                        ann.title = fullLocationArr[0]
                                        // halfAdd is the second half of the address which will be the subtitle
//                                        let halfAdd = fullLocationArr[1] + "," + fullLocationArr[2]
                                        // trim the whitespace from the front to clean up formatting
//                                        let trimmedString = halfAdd.trimmingCharacters(in: .whitespacesAndNewlines)
//                                        ann.subtitle = trimmedString
                                        // get latitude and longitudes for all other addresses
                                        let geoCoder = CLGeocoder()
                                        geoCoder.geocodeAddressString(location) { (placemarks, error) in
                                            guard
                                                let placemarks = placemarks,
                                                let location = placemarks.first?.location
                                                else {
                                                    // handle no location found
                                                    return
                                            }
                                            // set coordinates for the annotations
                                            ann.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                                            // add the annotations to the map
                                            self.map.addAnnotation(ann)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        } else {
            // error trapping
            print("Unable to validate user and query their gear")
        }
        // show the user's location
        map.showsUserLocation = true
        //        centerMapOnLocation(location: location)
    }
    
    // segue when you tap on the button for the pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // if the button pressed is the right callout button then trigger this conditional
        if control == view.rightCalloutAccessoryView {
            // reformat address to align with addresses stored in the database
            let current = view.annotation!.title!!
            // if the address isn't the current one
            if current != address {
                // create a new storyboard based on the tableviewcontroller file
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                // create new view controller based on the products at the given address
                let vc = Storyboard.instantiateViewController(withIdentifier: "AvaliableProducts") as! TableViewController
                db.collection("items").whereField("address", isEqualTo: current).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        // error handling
                        print("Error getting documents: \(err)")
                    } else {
                        // for each document, add it to the corresponding array in the other file
                        for document in querySnapshot!.documents {
                            // get all the product names at the address
                            let docData = document.data()
                            let itemName = docData["item_name"] as! String
                            vc.products.append(itemName)
                            
                            // get their corresponding prices
                            let priceStr = docData["price_per_day"] as! String
                            vc.prices.append("$" + priceStr)
                            
                            // get their corresponding conditions
                            let conditionStr = docData["item_condition"] as! String
                            vc.condition.append(conditionStr)
                            
                            // get their corresponding document details
                            let uid = docData["owner_UID"] as! String
                            let documentName = "\(String(describing: uid))-\(String(describing: itemName))"
                            vc.documents.append(documentName)
                        }
                        // present the new view controller
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            // don't need to error trap the else case because there's no annotation for the user's address
        }
    }
    
    // handle the pins on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            // create a pin view from the original annotations
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            // set button size
            let smallRect = CGSize(width: 25, height: 25)
            let rightButton = UIButton(frame: CGRect(origin: .zero, size: smallRect))
            
            // set features of the button on the right
            rightButton.tag = annotation.hash
            rightButton.backgroundColor = UIColor(red: 74/225.0, green: 182/255.0, blue: 213/255.0, alpha: 1.0)
            rightButton.layer.cornerRadius = 25/2
            rightButton.layer.borderWidth = 1
            rightButton.layer.borderColor = UIColor(red: 74/225.0, green: 182/255.0, blue: 213/255.0, alpha: 1.0).cgColor
            
            // add a label to provide text for the button
            let label = UILabel(frame: CGRect(x: -40, y: 3, width: 100, height: 15))
            label.textAlignment = .center
            label.text = " >"
            label.textColor = .white
            
            // add the label to the button
            rightButton.addSubview(label)
            // animate pin drop upon app start
            pinView.animatesDrop = true
            // show the "View Products" button on the right
            pinView.canShowCallout = true
            // set the button press to trigger the earlier function
            pinView.rightCalloutAccessoryView = rightButton
            return pinView
        }
        else {
            return nil
        }
    }
    
    // manage the location on the map
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        // center the map around given latitude and longitude
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = map.userLocation.coordinate
        // set correct region on the map based on prior information
        map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
