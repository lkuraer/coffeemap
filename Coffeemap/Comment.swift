//
//  Comment.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/14/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    var id: String?
    var date: String?
    var comment: String?
    var emoji: String?
    
    init(id: String, rawDictionary: [String: AnyObject]) {
        self.id = id
        if let date = rawDictionary["date"] as? String {
            self.date = date
        }
        
        if let comment = rawDictionary["comment"] as? String {
            self.comment = comment
        }
        
        if let emoji = rawDictionary["emoji"] as? String {
            self.emoji = emoji
        }
        
    }
}
