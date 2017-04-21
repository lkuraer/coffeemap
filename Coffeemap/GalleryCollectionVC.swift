//
//  GalleryCollectionVC.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 8/18/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GalleryCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    var ImageCache = [String:UIImage]()
    var imagesURL = [String]()
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = "Галерея"
        
        ActivityIndicator.handler.showActivityIndicator()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionGalleryCell", for: indexPath) as? CollectionGalleryCell {
            let i = indexPath.row
            
            let shopName = imagesURL[i]
            
            if let shopImage = ImageCache[shopName] {
                cell.galleryImage.image = shopImage
            } else {
                
                let imageURL = imagesURL[i]
                
                Alamofire.request(imageURL)
                    .responseImage { response in
                        //debugPrint(response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            
                            let newImage = self.resizeImage(image, newWidth: self.screenWidth)
                            
                            // Store the commit date in to our cache
                            self.ImageCache[shopName] = newImage
                            
                            // Update the cell
                            DispatchQueue.main.async(execute: {
                                if let cellToUpdate = self.collectionView.cellForItem(at: indexPath) as? CollectionGalleryCell {
                                    cellToUpdate.galleryImage.image = newImage
                                    ActivityIndicator.handler.hideActivityIndicator()
                                    self.images.append(newImage)
                                    self.collectionView.collectionViewLayout.invalidateLayout()
                                }
                            })
                            
                        } else {
                            print("error getting image at cell")
                        }
                }
            }
            
            return cell

        } else {
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let shopName = imagesURL[indexPath.row]
        if let shopImage = ImageCache[shopName] {
            print("found image")
            return CGSize(width: shopImage.size.width, height: shopImage.size.height)
        } else {
            return CGSize(width: screenWidth, height: 200)
        }
        
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    


}


