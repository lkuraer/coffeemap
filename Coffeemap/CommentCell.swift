//
//  CommentCell.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/14/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var smileLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: Comment, ratings: [RatingOfUser]) {
        dateLabel.text = comment.date
        commentLabel.text = comment.comment
        
        if let charString = comment.emoji {
            if let charCode = UInt32(charString, radix: 16),let unicode = UnicodeScalar(charCode) {
                let str = String(unicode)
                smileLabel.text = str
                print(str)
            }
            else {
                print("invalid input")
            }
        }
        
        for i in 0..<ratings.count {
            if comment.id == ratings[i].id {
                print("comment id: \(comment.id)")
                print("rating id: \(ratings[i].id)")
                print("rating: \(ratings[i].rating)")

                ratingImage.image = Utils.toRatingImage(ratings[i].rating!)
            }
        }
        
    }

}
