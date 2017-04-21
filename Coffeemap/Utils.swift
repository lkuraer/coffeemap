//
//  Utils.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/14/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func showOverAnyVC(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            
        })))
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func toRatingImage(_ rating: Int) -> UIImage {
        
        switch rating {
        case 5:
            return UIImage(named: "5star.pdf")!
        case 4:
            return UIImage(named: "4star.pdf")!
        case 3:
            return UIImage(named: "3star.pdf")!
        case 2:
            return UIImage(named: "2star.pdf")!
        case 1:
            return UIImage(named: "1star.pdf")!
        default:
            return UIImage(named: "notrated.pdf")!
        }
    }
    

    
}
