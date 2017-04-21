//
//  ShopDetailVC.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/28/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import AlamofireImage

class ShopDetailVC: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var phoneButton: ButtonHelper!
    @IBOutlet weak var mapButton: ButtonHelper!
    @IBOutlet weak var yellowBorderView: UIView!
    @IBOutlet weak var placeHolderText: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var galleryViewImage: UIImageView!
    @IBOutlet weak var galleryPlaceholderView: UIView!
    @IBOutlet weak var imageGallery: UIView!
    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var photoIcon: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var capuchinoLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var otzivButton: ButtonHelper!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!

    let ref = FIRDatabase.database().reference().child("shops")
    var shop: CoffeeShop!
    var latitude = 0.0
    var longitude = 0.0
    var name = ""
    var imagesToPass = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneButton.setImage(UIImage(named: "phone.pdf"), for: UIControlState())
        navigationItem.title = "Описание"
        addressLabel.text = shop.address
        ratingImage.image = Utils.toRatingImage(shop.ratings)
        yellowBorderView.layer.borderWidth = 1
        yellowBorderView.layer.borderColor = YELLOW_COLOR.cgColor
        placeHolderText.setLineHeight(1.3)
        
        shopNameLabel.text = shop.name
        
        let recommended = self.shop.recommended
        if recommended {
            recommendLabel.isHidden = false
        } else {
            recommendLabel.isHidden = true
        }
        
        if shop.hours == "" {
            hoursLabel.text = "Часы работы не известно"
        } else {
            hoursLabel.attributedText = composeAttributedString(boldText: "Часы работы: ", regularString: shop.hours)
        }
        
        if let wifi = shop.wifi {
            wifiLabel.isHidden = false
            if wifi {
                wifiLabel.attributedText = composeAttributedString(boldText: "WiFi: ", regularString: "есть")
            } else {
                wifiLabel.attributedText = composeAttributedString(boldText: "WiFi: ", regularString: "нет")
            }
        } else {
            wifiLabel.isHidden = true
        }
        
        if let cap = shop.cap {
            capuchinoLabel.isHidden = false
            capuchinoLabel.attributedText = composeAttributedString(boldText: "Капучино: ", regularString: cap)
        } else {
            capuchinoLabel.isHidden = true
        }
        
        if let fee = shop.fee {
            feeLabel.isHidden = false
            feeLabel.attributedText = composeAttributedString(boldText: "Обслуживание: ", regularString: fee)
        } else {
            feeLabel.isHidden = true
        }
        
        galleryViewImage.clipsToBounds = true
        
        if shop.telephone == 0 {
            phoneButton.isHidden = true
        }
        
        if shop.description == "" {
            descriptionLabel.text = "Описания пока нет."
        } else {
            descriptionLabel.text = shop.description
            descriptionLabel.setLineHeight(1.3)
        }
        
        if let images = shop.images {
            self.imagesToPass = images
            galleryPlaceholderView.isHidden = true
            imageGallery.isHidden = false
            let imageURL = URL(string: images[0])
            photoCount.text = "\(images.count)"
            photoIcon.tintColor = UIColor.white
            photoIcon.addShadow()
            photoCount.addShadow()
            activity.startAnimating()
            
            galleryViewImage.af_setImage(withURL: imageURL!, placeholderImage: PLACEHOLDER!, filter: nil, imageTransition: .crossDissolve(0.2), completion: { (response) -> Void in
                self.activity.stopAnimating()
                self.activity.isHidden = true
            })
        } else {
            imageGallery.isHidden = true
            galleryPlaceholderView.isHidden = false
        }
        
        latitude = Double(shop.latitude)!
        longitude = Double(shop.longitude)!
        name = shop.name
        
        let attrs = [
            NSForegroundColorAttributeName: YELLOW_COLOR,
            NSUnderlineStyleAttributeName: 1
        ] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let buttonTitleString = NSMutableAttributedString(string: "Контактная информация", attributes: attrs)
        attributedString.append(buttonTitleString)
        contactButton.setAttributedTitle(attributedString, for: UIControlState())
        
    }
    
    func composeAttributedString(boldText: String, regularString: String) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = 1.3
        
        let attrString = NSMutableAttributedString(string: boldText)
        let attrString2 = NSMutableAttributedString(string: regularString)
        
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "LitteraTextBold", size: 14.0)!, range: NSMakeRange(0, attrString.length))
        attrString2.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, attrString2.length))
        
        attrString.append(attrString2)
        
        return attrString
    }
    

    @IBAction func toGalleryButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToGalleryCollection", sender: self)
    }
    
    @IBAction func contactButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "showContacts", sender: self)
    }
    
    @IBAction func phoneButtonTapped(_ sender: AnyObject) {
        
        let tel = shop.telephone
        let string = "tel://+998\(tel)"
        
        let url: URL? = URL(string: string)
        UIApplication.shared.openURL(url!)

    }
    
    @IBAction func mapButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "showShopOnMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showShopOnMap" {
            if let coffeeShopDetails = sender as? ShopDetailVC, let shopOnMap = segue.destination as? CoffeeShopMapVC {
                shopOnMap.latitude = coffeeShopDetails.latitude
                shopOnMap.longitude = coffeeShopDetails.longitude
                shopOnMap.name = coffeeShopDetails.name
            }
        } else if segue.identifier == "goToGalleryCollection" {
            if let coffeeShopDetails = sender as? ShopDetailVC, let imageGalleryCollection = segue.destination as? GalleryCollectionVC {
                imageGalleryCollection.imagesURL = coffeeShopDetails.imagesToPass
            }

        }
        
        if segue.identifier == "showComments" {
            let controller = segue.destination as! CommentsVC
            controller.shop = self.shop
        }
        

    }
    
    
    @IBAction func otzivButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showComments", sender: self)
    }
    


}





























