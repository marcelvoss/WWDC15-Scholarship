//
//  MapViewer.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 18.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit
import MapKit

class MapViewer: UIView {
    
    var mapView : MKMapView?
    var effectView = UIVisualEffectView()
    var aWindow : UIWindow?
    var closeButton = UIButton()
    var constraintY : NSLayoutConstraint?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        aWindow = UIApplication.sharedApplication().keyWindow!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        self.setupViews()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.effectView.alpha = 1
            self.closeButton.alpha = 1
        })
        
        UIView.animateWithDuration(0.4, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
            self.constraintY!.constant = 0
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.effectView.alpha = 0
            self.closeButton.alpha = 0
        }) { (finished) -> Void in
            self.mapView!.delegate = nil;
            self.mapView!.removeFromSuperview();
            self.mapView = nil;
            
            self.effectView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
            self.constraintY!.constant = self.frame.size.height
            self.layoutIfNeeded()
            }) { (finished) -> Void in
            self.mapView?.removeFromSuperview()
        }
    }
    
    func setupViews () {
        aWindow?.addSubview(self)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.frame
        effectView.alpha = 0
        self.addSubview(effectView)
        
        closeButton.alpha = 0
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.addTarget(self, action: "hide", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "CloseIcon"), forState: UIControlState.Normal)
        self.addSubview(closeButton)
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20))
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        
        // Map
        mapView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(mapView!)
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        constraintY = NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: self.frame.size.height)
        
        self.addConstraint(constraintY!)
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: mapView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        var tap = UITapGestureRecognizer(target: self, action: "hide")
        effectView.addGestureRecognizer(tap)
        
        self.layoutIfNeeded()
    }

}
