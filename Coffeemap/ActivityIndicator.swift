//
//  ActivityIndicator.swift
//  Coffeemap
//
//  Created by Ruslan Sabirov on 3/14/17.
//  Copyright © 2017 Ruslan Sabirov. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: UIView {
    static let handler = ActivityIndicator()
    
    let alertWindow = UIApplication.shared.keyWindow!
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var isShown = false
    
    func rotated() {
        if isShown {
            loadingView.center = alertWindow.center
            alertWindow.layoutSubviews()
            alertWindow.layoutIfNeeded()
        }
    }
    
    func showActivityIndicator() {
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityIndicator.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if isShown {
            
        } else {
            show()
        }
    }
    
    func hideActivityIndicator() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        hide()
    }
    
    private func show() {
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = alertWindow.center
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        
        alertWindow.addSubview(loadingView)
        actInd.startAnimating()
        isShown = true
    }
    
    private func hide() {
        loadingView.removeFromSuperview()
        actInd.stopAnimating()
        isShown = false
    }
    
}
