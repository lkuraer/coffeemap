//
//  FirstViewController.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/21/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import GoogleMaps

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITabBarDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapContainer: GMSMapView!
    
    var locationManager = CLLocationManager()
    var myLatitude = 41.312301
    var myLongitude = 69.28209
    var coffeeshops = [CoffeeShop]()
    var manager: OneShotLocationManager?
    var selectedShop: CoffeeShop!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeArrow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapContainer.delegate = self

        ActivityIndicator.handler.showActivityIndicator()
        
        navigationItem.title = "Карта кофеен Ташкента"
        
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.notDetermined){
            locationManager.requestWhenInUseAuthorization()
        } else if authstate == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            manager = OneShotLocationManager()
            manager!.fetchWithCompletion {location, error in
                
                // fetch location or an error
                if location != nil {
                    
                    self.myLatitude = location!.coordinate.latitude
                    self.myLongitude = location!.coordinate.longitude
                    
                    let camera = GMSCameraPosition.camera(withLatitude: self.myLatitude, longitude: self.myLongitude, zoom: 15)
                    self.mapContainer.isMyLocationEnabled = true
                    
                    self.mapContainer.camera = camera
                    
                    let ref = FIRDatabase.database().reference().child("shops")
                    
                    ref.observe(.value, with: { (snapshot) in
                        ActivityIndicator.handler.hideActivityIndicator()
                        self.coffeeshops = [CoffeeShop]()
                        
                        if let shopsDict = snapshot.value as! [String: AnyObject]! {
                            for (key, value) in shopsDict {
                                
                                let latitude = self.getLat((value["coordinates"] as? String)!)
                                let longitude = self.getLong((value["coordinates"] as? String)!)
                                
                                let myLocation = CLLocation(latitude: self.myLatitude, longitude: self.myLongitude)
                                
                                let coffeeShopLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                                
                                let distance = self.distanceBetweenTwoLocations(coffeeShopLocation, destination: myLocation)
                                
                                let shop = CoffeeShop(uri: key, data: value as! [String : AnyObject], distance: distance)
                                self.coffeeshops.append(shop)
                                
                                
                            }
                            
                        }
                        
                        for i in 0..<self.coffeeshops.count {
                            
                            let coffeeTitle = self.coffeeshops[i].name
                            var distanceLabel = ""
                            if let distance = self.coffeeshops[i].distance {
                                distanceLabel = "\(distance) км"
                            } else {
                                distanceLabel = "10 км"
                            }
                            
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: Double(self.coffeeshops[i].latitude)!, longitude: Double(self.coffeeshops[i].longitude)!)
                            marker.title = coffeeTitle
                            marker.snippet = distanceLabel
                            marker.icon = UIImage(named: "pin.pdf")
                            
                            marker.map = self.mapContainer
                            
                            self.mapContainer.selectedMarker = marker
                        }
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                } else if let err = error {
                    print(err.localizedDescription)
                }
                self.manager = nil
            }
            
        }

    }
        
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        for i in 0..<self.coffeeshops.count {
            if marker.title == self.coffeeshops[i].name {
                print(self.coffeeshops[i].name)
                self.selectedShop = self.coffeeshops[i]
                
                performSegue(withIdentifier: "fromAnnotationToDetails", sender: self)
            }
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        ActivityIndicator.handler.hideActivityIndicator()
    }

    func distanceBetweenTwoLocations(_ source: CLLocation, destination: CLLocation) -> Double {
        let distanceMeters = source.distance(from: destination)
        let distanceKM = distanceMeters / 1000
        let roundedTwoDigit = round(10 * distanceKM)/10
        return roundedTwoDigit
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        myLatitude = location.coordinate.latitude
        myLongitude = location.coordinate.longitude
    }
    
    func getLat(_ coordinates: String) -> String {
        var coordinatesArray = [String]()
        coordinatesArray = coordinates.components(separatedBy: ", ")
        return coordinatesArray[0]
    }
    
    func getLong(_ coordinates: String) -> String {
        var coordinatesArray = [String]()
        coordinatesArray = coordinates.components(separatedBy: ", ")
        return coordinatesArray[1]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromAnnotationToDetails" {
            let controller = segue.destination as? ShopDetailVC
            controller?.shop = self.selectedShop
        }
        
    }
    
    func changeArrow() {
        let inserts = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        let imgBackArrow = UIImage(named: "back_arrow")?.withAlignmentRectInsets(inserts) // Load the image centered
        
        self.navigationController?.navigationBar.backIndicatorImage = imgBackArrow // Set the image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow // Set the image mask
    }


}





