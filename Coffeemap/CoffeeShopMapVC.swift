//
//  CoffeeShopMapVC.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 8/2/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import GoogleMaps

class CoffeeShopMapVC: UIViewController {
    
    var latitude = 0.0
    var longitude = 0.0
    var name = ""
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "На карте"
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 16)
        
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title = name
        marker.icon = UIImage(named: "pin.pdf")
        marker.map = mapView
        
    }
    

}
