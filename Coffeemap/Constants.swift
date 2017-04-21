//
//  Constants.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/25/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

let YELLOW_COLOR = UIColor(red:0.96, green:0.92, blue:0.13, alpha:1.00)
let UID_KEY = "uid"
let GRAY_COLOR = UIColor(red:0.36, green:0.42, blue:0.47, alpha:1.00)
var USER_ID = ""
let DATE_FORMAT = "dd.MM.yyyy"


let PLACEHOLDER = UIImage(named: "bgc")

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.5
    }
}

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 60 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 20 * 1024 * 1024
)

let EMOJI =  ["1F601", "1F602", "1F603", "1F604", "1F605", "1F606", "1F608", "1F609", "1F60A", "1F60С", "1F61С", "1F61D", "1F633", "1F63C", "1F646", "1F648", "1F64B", "1F680", "1F68C", "1F695", "1F6B2", "1F6C0", "1F1EC", "1F1EB", "1F1FA", "2615", "261D", "2665", "26C5", "1F300", "1F31B", "1F320", "1F337", "1F33D", "1F347", "1F346", "1F34C", "1F351", "1F352", "1F353", "1F36B", "1F380", "1F384", "1F3AE", "1F3BA", "1F3E9", "1F40D", "1F412", "1F419", "1F444"]
