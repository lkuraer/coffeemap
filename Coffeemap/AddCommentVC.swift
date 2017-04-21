//
//  AddCommentVC.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/22/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import KMPlaceholderTextView

class AddCommentVC: UIViewController {
    
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var voteButton2: UIButton!
    @IBOutlet weak var voteButton3: UIButton!
    @IBOutlet weak var voteButton4: UIButton!
    @IBOutlet weak var voteButton5: UIButton!
    @IBOutlet weak var saveComment: UIButton!
    @IBOutlet weak var commentField: KMPlaceholderTextView!

    
    let ref = FIRDatabase.database().reference().child("shops")
    var shop: CoffeeShop!
    
    var selectedRating = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ваш отзыв"
        
        saveComment.layer.cornerRadius = 3
        
        commentField.layer.cornerRadius = 5

        ref.child("\(shop.uri)/ratings").child(USER_ID).observe(.value, with: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.userRatingImage(0)
            } else {
                self.selectedRating = snapshot.value as! Int
                self.userRatingImage(self.selectedRating)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.ref.child("\(self.shop.uri)/comments").child(USER_ID).child("comment").observe(.value, with: { (snapshot) in
            
            if snapshot.value is NSNull {
                self.commentField.placeholder = "Введите свой комментарий"
            } else {
                self.commentField.text = "\(snapshot.value!)"
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    

    @IBAction func voteTapped(_ sender: AnyObject) {
        selectedRating = 1
        userRatingImage(1)
    }
    
    @IBAction func voteTapped2(_ sender: AnyObject) {
        selectedRating = 2
        userRatingImage(2)
    }
    
    @IBAction func voteTapped3(_ sender: AnyObject) {
        selectedRating = 3
        userRatingImage(3)
    }
    
    @IBAction func voteTapped4(_ sender: AnyObject) {
        selectedRating = 4
        userRatingImage(4)
    }
    @IBAction func voteTapped5(_ sender: AnyObject) {
        selectedRating = 5
        userRatingImage(5)
    }

    func userRatingImage(_ rating: Int) -> Void {
        
        switch rating {
        case 5:
            voteButton.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
        case 4:
            voteButton.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
        case 3:
            voteButton.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
        case 2:
            voteButton.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
        case 1:
            voteButton.setImage(UIImage(named: "star-1.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
        default:
            voteButton.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton2.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton3.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton4.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
            voteButton5.setImage(UIImage(named: "starempty.pdf"), for: UIControlState())
        }
    }

    func addNew() {
        let alertController = UIAlertController(title: "Добавить новый отзыв", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Отправить", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            print("название \(firstTextField.text)")
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveUserComment() {

        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMAT
        let stringDate = formatter.string(from: currentDate)
        
        let randomNumber = Int(arc4random_uniform(UInt32(EMOJI.count)))
        let randomEmoji = EMOJI[randomNumber]
        
        print(stringDate)
        
        if let commentText = commentField.text, commentText != "" {
            
            ref.child("\(shop.uri)/ratings").child(USER_ID).setValue(selectedRating)
            
            self.ref.child("\(self.shop.uri)/comments").child(USER_ID).child("comment").setValue(commentText)
            
            self.ref.child("\(self.shop.uri)/comments").child(USER_ID).child("date").setValue(stringDate)
            
            self.ref.child("\(self.shop.uri)/comments").child(USER_ID).child("emoji").observe(.value, with: { (snapshot) in
                
                if snapshot.value is NSNull {
                    self.ref.child("\(self.shop.uri)/comments").child(USER_ID).child("emoji").setValue(randomEmoji)
                }
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        } else {
            Utils.showOverAnyVC("Ошибка", message: "Поле комментария обязательно к заполнению")
        }

    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveUserComment()
    }
    
}




















