//
//  Rating.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/22/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

class RatingOfUser {
    var id: String?
    var rating: Int?
    
    init(id: String, rating: Int) {
        self.id = id
        self.rating = rating
    }
}
