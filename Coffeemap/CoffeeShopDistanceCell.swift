//
//  CoffeeShopDistanceCell.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 8/1/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit

class CoffeeShopDistanceCell: UITableViewCell {
    
    var coffeeShop: CoffeeShop!
    @IBOutlet weak var coffeeShopLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var wifiStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ coffeeShop: CoffeeShop) {
        self.coffeeShop = coffeeShop
        coffeeShopLabel.text = self.coffeeShop.name
        addressLabel.text = self.coffeeShop.address
        let recommended = self.coffeeShop.recommended
        if recommended {
            recommendedLabel.isHidden = false
        } else {
            recommendedLabel.isHidden = true
        }
        let new = self.coffeeShop.new
        if new {
            newImage.isHidden = false
        } else {
            newImage.isHidden = true
        }
        ratingLabel.image = Utils.toRatingImage(coffeeShop.ratings)
        
        if let distance = self.coffeeShop.distance {
            distanceLabel.text = "\(distance) км"
        } else {
            distanceLabel.text = "10 км"
        }
        
        if let wifi = coffeeShop.wifi {
            wifiStackView.isHidden = false
            if wifi {
                wifiStackView.isHidden = true
            } else {
                wifiStackView.isHidden = false
            }
        } else {
            wifiStackView.isHidden = true
        }
        
    }
    
    
    
}
