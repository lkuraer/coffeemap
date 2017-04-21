//
//  ButtonHelper.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 7/25/16.
//  Copyright © 2016 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

class ButtonHelper: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.tintColor = YELLOW_COLOR
        self.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0)
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = YELLOW_COLOR.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.clear

    }

}

class ButtonHelper2: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.tintColor = UIColor.black
        self.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 0)
        self.layer.cornerRadius = 3.0
        self.backgroundColor = YELLOW_COLOR
        
    }
    
}
