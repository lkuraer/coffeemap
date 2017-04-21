//
//  ThirdViewController.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/25/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var coffeeshops = [CoffeeShop]()
    var sortedCoffeeshops = [CoffeeShop]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeArrow()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ActivityIndicator.handler.showActivityIndicator()
        navigationItem.title = "Кофейни"
        
        let ref = FIRDatabase.database().reference().child("shops")
        
        ref.observe(.value, with: { (snapshot) in
            self.coffeeshops = [CoffeeShop]()
            
            if let shopsDict = snapshot.value as! [String: AnyObject]! {
                for (key, value) in shopsDict {
                    let shop = CoffeeShop(uri: key, data: value as! [String : AnyObject])
                    self.coffeeshops.append(shop)
                }
            }
            
            self.sortedCoffeeshops = self.coffeeshops.sorted(by: { (dictOne, dictTwo) -> Bool in
                let d1 = dictOne.name as String
                let d2 = dictTwo.name as String
                
                return d1 < d2
            })
            
            ActivityIndicator.handler.hideActivityIndicator()
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        ActivityIndicator.handler.hideActivityIndicator()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCoffeeshops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeShopCell", for: indexPath) as? CoffeeShopCell {
            
            let coffeeShop = sortedCoffeeshops[indexPath.row]
            
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
        
        if let oneSectionCell = sender as? CoffeeShopCell, let shopDetailPage = segue.destination as? ShopDetailVC {
            shopDetailPage.shop = oneSectionCell.coffeeShop
        }

    }
    
    func changeArrow() {
        let inserts = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        let imgBackArrow = UIImage(named: "back_arrow")?.withAlignmentRectInsets(inserts) // Load the image centered
        
        self.navigationController?.navigationBar.backIndicatorImage = imgBackArrow // Set the image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow // Set the image mask
    }

    

}
