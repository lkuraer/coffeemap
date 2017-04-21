//
//  CommentsVC.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/14/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    
    let ref = FIRDatabase.database().reference().child("shops")
    var shop: CoffeeShop!
    var comments = [Comment]()
    var ratings = [RatingOfUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Отзывы"

        tableView.delegate = self
        tableView.dataSource = self
        
        addCommentButton.layer.cornerRadius = 3
        
        self.ref.child("\(self.shop.uri)/comments").observe(.value, with: { (snapshot) in
            self.comments = [Comment]()
            
            if snapshot.value is NSNull {
                self.noCommentsLabel.isHidden = false
            } else {
                self.noCommentsLabel.isHidden = true
                if let commentsDict = snapshot.value as! [String: AnyObject]! {
                    for (key, value) in commentsDict {
                        let comment = Comment(id: key, rawDictionary: value as! [String : AnyObject])
                        self.comments.append(comment)
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.ref.child("\(self.shop.uri)/ratings").observe(.value, with: { (snapshot) in
            self.ratings = [RatingOfUser]()
            
            if snapshot.value is NSNull {
                
            } else {
                if let ratingssDict = snapshot.value as! [String: AnyObject]! {
                    for (key, value) in ratingssDict {
                        let rating = RatingOfUser(id: key, rating: value as! Int)
                        self.ratings.append(rating)
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }

        ref.child("\(shop.uri)/comments").child(USER_ID).observe(.value, with: { (snapshot) in

            if snapshot.value is NSNull {
                self.addCommentButton.titleLabel?.text = "Добавить отзыв"
            } else {
                self.addCommentButton.titleLabel?.text = "Изменить отзыв"
            }
            
            self.tableView.reloadData()

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            
            let comment = comments[indexPath.row]
            
            cell.configureCell(comment: comment, ratings: self.ratings)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
        performSegue(withIdentifier: "addCommentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCommentSegue" {
            let controller = segue.destination as! AddCommentVC
            controller.shop = self.shop
        }
    }
    
}







