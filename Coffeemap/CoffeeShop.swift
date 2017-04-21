//
//  CoffeeShop.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/26/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class Rating {
    var userID: String?
    var vote: Int?
    
    init(userID: String, vote: Int) {
        self.userID = userID
        self.vote = vote
    }
}

class CoffeeShop {
    fileprivate var _uri: String!
    fileprivate var _name: String!
    fileprivate var _latitude: String!
    fileprivate var _longitude: String!
    fileprivate var _telephone: Int!
    fileprivate var _address: String!
    fileprivate var _description: String!
    fileprivate var _hours: String!
    fileprivate var _recommended: Bool!
    fileprivate var _new: Bool!
    fileprivate var _ratings: Int!
    var images: [String]?
    var distance: Double?
    var wifi: Bool?
    var cap: String?
    var fee: String?
    var comments: [Comment]?
    
    var ratings: Int {
        return _ratings
    }
    
    var uri: String {
        return _uri
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var latitude: String {
        if _latitude == nil {
            _latitude = ""
        }
        return _latitude
    }
    
    var longitude: String {
        if _longitude == nil {
            _longitude = ""
        }
        return _longitude
    }
    
    var telephone: Int {
        if _telephone == nil {
            _telephone = 0
        }
        return _telephone
    }
    
    var address: String {
        if _address == nil {
            _address = ""
        } else if _address == "" {
            _address = "Адреса пока нет"
        }
        return _address
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var hours: String {
        if _hours == nil {
            _hours = ""
        }
        return _hours
    }
    
    var recommended: Bool {
        return _recommended
    }
    
    var new: Bool {
        return _new
    }
    
    init(uri: String, data: [String: AnyObject]) {
        self._uri = uri
        self._name = data["name"] as? String
        self._latitude = getLat((data["coordinates"] as? String)!)
        self._longitude = getLong((data["coordinates"] as? String)!)
        self._telephone = data["tel"] as? Int
        self._address = data["address"] as? String
        self._description = data["description"] as? String
        self._hours = data["hours"] as? String
        self._recommended = data["recommended"] as? Bool
        self._new = data["new"] as? Bool
        if data["ratings"] == nil {
            self._ratings = 0
        } else {
            if let ratingDict = data["ratings"] as! [String: Int]! {
                self._ratings = getRating(ratingDict)
            }
        }
        
        if let wifi = data["wifi"] as? Bool {
            self.wifi = wifi
        }
        
        if let cap = data["cap"] as? String {
            self.cap = cap
        }
        
        if let fee = data["fee"] as? String {
            self.fee = fee
        }
        
        if let imagesDict = data["images"] as? [String] {
            self.images = imagesDict
        }
        
        if let comments = data["comments"] as? [String: AnyObject] {
            self.comments = [Comment]()
            for (key, value) in comments {
                let comment = Comment(id: key, rawDictionary: value as! [String : AnyObject])
                self.comments?.append(comment)
            }
        }
    }
    
    init(uri: String, data: [String: AnyObject], distance: Double) {
        self._uri = uri
        self._name = data["name"] as? String
        self._latitude = getLat((data["coordinates"] as? String)!)
        self._longitude = getLong((data["coordinates"] as? String)!)
        self._telephone = data["tel"] as? Int
        self._address = data["address"] as? String
        self._description = data["description"] as? String
        self._hours = data["hours"] as? String
        self._recommended = data["recommended"] as? Bool
        self._new = data["new"] as? Bool
        if data["ratings"] == nil {
            self._ratings = 0
        } else {
            if let ratingDict = data["ratings"] as! [String: Int]! {
                self._ratings = getRating(ratingDict)
            }
        }
        self.distance = distance
        
        if let wifi = data["wifi"] as? Bool {
            self.wifi = wifi
        }
        
        if let cap = data["cap"] as? String {
            self.cap = cap
        }
        
        if let fee = data["fee"] as? String {
            self.fee = fee
        }
        
        if let imagesDict = data["images"] as? [String] {
            self.images = imagesDict
        }

        if let comments = data["comments"] as? [String: AnyObject] {
            self.comments = [Comment]()
            for (key, value) in comments {
                let comment = Comment(id: key, rawDictionary: value as! [String : AnyObject])
                self.comments?.append(comment)
            }
        }
    }
    
//    func getStringArray(_ data: [String]) -> [String] {
//        var array = [String]()
//        for (key, value) in data {
//            let slide = SlideImage(id: key, url: value)
//            array.append(slide)
//        }
//        return array
//    }
    
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
    
    func getRating(_ data: [String: Int]) -> Int {
        var ratingCount = 0
        var ratingSum = 0
        var ratingArray = [Int]()
        for (_, value) in data {
            ratingArray.append(value)
        }
        for i in 0..<ratingArray.count {
            ratingSum = ratingSum + ratingArray[i]
        }
        
        ratingCount = (ratingSum / ratingArray.count)
        return ratingCount
    }
    
    
}





































