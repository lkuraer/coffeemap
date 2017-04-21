//
//  FourthViewController.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/25/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import UIKit
import ActiveLabel
import MessageUI

class FourthViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var tgButton: UIButton!
    @IBOutlet weak var firstBlockLabel: ActiveLabel!
    @IBOutlet weak var secondBlockLabel: ActiveLabel!
    @IBOutlet weak var thirdBlock: ActiveLabel!
    @IBOutlet weak var shareWithFriendsButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeArrow()
        
        navigationItem.title = "Контакты"
        
        //MARK: need to refactor here
        emailButton.setImage(UIImage(named: "email.pdf"), for: UIControlState())
        fbButton.setImage(UIImage(named: "fb.pdf"), for: UIControlState())
        tgButton.setImage(UIImage(named: "tg.pdf"), for: UIControlState())
        
        firstBlockLabel.setLineHeight(1.3)
        firstBlockLabel.customize { label in
            label.text = "Приложение, веб сайт http://coffeemap.uz и @coffeemapbot в Телеграмe  позволяют найти кофейни на карте Ташкента. На карту мы добавляем только заведения, куда гости приходят выпить кофе. Таким образом, в приоритете у нас кофейни и другие заведения, где имеется кофейная карта в меню и хозяева активно предлагают кофе гостям."
            label.mentionColor = YELLOW_COLOR
            label.URLColor = YELLOW_COLOR
            label.handleURLTap {
                url in UIApplication.shared.openURL(url)
            }
            label.handleMentionTap {
                url in UIApplication.shared.openURL(NSURL(string: "http://telegram.me/coffeemapbot")! as URL)
            }
            label.setLineHeight(1.3)
        }
        
        secondBlockLabel.setLineHeight(1.3)
        secondBlockLabel.customize { label in
            label.text = "Информацию о заведении мы предоставляем на свое усмотрение. Если вы хотите разместить свои материалы, рекламу, выделить точку на карте или в списках — свяжитесь с нами по #почте или через #Фейсбук."
            label.hashtagColor = YELLOW_COLOR
            label.handleHashtagTap {
                hastag in
                if hastag == "почте" {
                    self.sendEmail()
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/coffeemap.uz/")! as URL)
                }
            }
            label.setLineHeight(1.3)
        }
        
        thirdBlock.setLineHeight(1.3)
        thirdBlock.customize { label in
            label.text = "Если вы обнаружили ошибку, неточность на карте или в описании, хотите #оставить отзыв или предложение — свяжитесь с нами."
            label.hashtagColor = YELLOW_COLOR
            label.handleHashtagTap {
                hastag in UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/coffeemap.uz/")! as URL)
            }
            label.setLineHeight(1.3)
        }
        
        let attrs = [
            NSForegroundColorAttributeName: YELLOW_COLOR,
            NSUnderlineStyleAttributeName: 1
        ] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleString = NSMutableAttributedString(string: "Расскажите о сервисе друзьям!", attributes: attrs)
        attributedString.append(buttonTitleString)
        shareWithFriendsButton.setAttributedTitle(attributedString, for: UIControlState())
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["keetano@yandex.ru"])
            mail.setMessageBody("<p>Связь с Coffeemap</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            alert("Не настроен почтовый клиент", message: "Пишите на: keetano@yandex.ru")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: AnyObject) {
        
        let textToShare = "Поиск кофеен в Ташкенте!"
        
        if let myWebsite = URL(string: "http://facebook.com/coffeemap.uz/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }

    }
    
    @IBAction func emailButtonTapped(_ sender: AnyObject) {
        self.sendEmail()
    }
    
    @IBAction func fbButtonTapped(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/coffeemap.uz/")!)
    }
    
    @IBAction func tgButtonTapped(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://telegram.me/coffeemapbot")!)
    }
    
    func changeArrow() {
        let inserts = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        let imgBackArrow = UIImage(named: "back_arrow")?.withAlignmentRectInsets(inserts) // Load the image centered
        
        self.navigationController?.navigationBar.backIndicatorImage = imgBackArrow // Set the image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow // Set the image mask
    }

    
}






    



