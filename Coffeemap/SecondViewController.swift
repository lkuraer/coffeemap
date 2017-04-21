//
//  SecondViewController.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/21/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class SecondViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocation(latitude: 41.312301, longitude: 69.28209)
    var coffeeshops = [CoffeeShop]()
    var sortedCoffeeshops = [CoffeeShop]()
    var onlyFiveCoffeeShops = [CoffeeShop]()
    @IBOutlet weak var tableView: UITableView!
    var manager: OneShotLocationManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeArrow()
        
        setTabBarActiveBG()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ActivityIndicator.handler.showActivityIndicator()
        locationManager.delegate = self
        
        navigationItem.title = "Рядом"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        defineLocation()
    }
    
    func defineLocation() {
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if location != nil {
                
                let myLatitude = location!.coordinate.latitude
                let myLongitude = location!.coordinate.longitude
                self.myLocation = CLLocation(latitude: myLatitude, longitude: myLongitude)
                
                let ref = FIRDatabase.database().reference().child("shops")
                
                ref.observe(.value, with: { (snapshot) in
                    ActivityIndicator.handler.hideActivityIndicator()
                    self.coffeeshops = [CoffeeShop]()
                    
                    if let shopsDict = snapshot.value as! [String: AnyObject]! {
                        print(shopsDict)
                        for (key, value) in shopsDict {
                            
                            let latitude = self.getLat((value["coordinates"] as? String)!)
                            let longitude = self.getLong((value["coordinates"] as? String)!)
                            
                            let coffeeShopLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                            
                            let distance = self.distanceBetweenTwoLocations(coffeeShopLocation, destination: self.myLocation)
                            
                            let shop = CoffeeShop(uri: key, data: value as! [String : AnyObject], distance: distance)
                            self.coffeeshops.append(shop)
                            
                            self.sortedCoffeeshops = self.coffeeshops.sorted(by: { (dictOne, dictTwo) -> Bool in
                                let d1 = dictOne.distance! as Double
                                let d2 = dictTwo.distance! as Double
                                
                                return d1 < d2
                            })
                            
                            self.onlyFiveCoffeeShops = self.sortedCoffeeshops.takeElements(5)
                        }
                        
                    }
                    
                    ActivityIndicator.handler.hideActivityIndicator()
                    self.tableView.reloadData()
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
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
        let center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        myLocation = center
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlyFiveCoffeeShops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeShopDistanceCell", for: indexPath) as? CoffeeShopDistanceCell {
            
            let coffeeShop = onlyFiveCoffeeShops[indexPath.row]
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.18, alpha:1.00)
            cell.selectedBackgroundView = bgColorView
            
            cell.configureCell(coffeeShop)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let oneSectionCell = sender as? CoffeeShopDistanceCell, let shopDetailPage = segue.destination as? ShopDetailVC {
            shopDetailPage.shop = oneSectionCell.coffeeShop
        }
        
    }

    @IBAction func moreResultsTapped(_ sender: AnyObject) {
        
        if onlyFiveCoffeeShops.count <= sortedCoffeeshops.count {
            ActivityIndicator.handler.showActivityIndicator()
            onlyFiveCoffeeShops = sortedCoffeeshops.takeElements(onlyFiveCoffeeShops.count + 5)
            tableView.reloadData()
            ActivityIndicator.handler.hideActivityIndicator()
        }
        
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        defineLocation()
    }
    
    func setTabBarActiveBG() {
        let numberOfItems = CGFloat((tabBarController?.tabBar.items!.count)!)
        
        let tabBarItemSize = CGSize(width: (tabBarController?.tabBar.frame.width)! / numberOfItems, height: (tabBarController?.tabBar.frame.height)!)
        
        tabBarController?.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.black, size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        tabBarController?.tabBar.frame.size.width = self.view.frame.width + 4
        tabBarController?.tabBar.frame.origin.x = -2
                
    }

    func changeArrow() {
        let inserts = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        let imgBackArrow = UIImage(named: "back_arrow")?.withAlignmentRectInsets(inserts) // Load the image centered
        
        self.navigationController?.navigationBar.backIndicatorImage = imgBackArrow // Set the image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow // Set the image mask
    }


}











