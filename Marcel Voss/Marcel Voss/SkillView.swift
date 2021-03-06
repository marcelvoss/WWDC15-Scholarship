//
//  SkillView.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 19.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit

class SkillView: UIView {
    
    var innerView = UIView()
    var percentage : Int?
    var container = UIView()
    var since : String?
    
    let sinceLabel = UILabel()
    
    var percentageLabel = UILabel()
    var nameLabel = UILabel()

    init(name: String, percentage: Int, color: UIColor, since: String,frame: CGRect) {
        super.init(frame: frame)
        
        self.percentage = percentage
        self.since = since
        
        // Container that "contains" the bar
        container = UIView(frame: CGRectMake(0, 10, self.frame.size.width - 40, self.frame.size.height - 20))
        container.layer.cornerRadius = container.frame.size.height / 2
        container.layer.borderColor = color.CGColor
        container.layer.borderWidth = 2.0
        self.addSubview(container)
        
        // This view shows the current percentage in a bar style
        innerView.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y, container.frame.size.width, container.frame.size.height)
        innerView.layer.cornerRadius = innerView.frame.size.height / 2
        innerView.backgroundColor = color
        self.addSubview(innerView)
        
        if (self.since != nil) {
            // Add a long press gesture recognizer
            // Only if the since property is not nil
            let pressRecognizer = UILongPressGestureRecognizer(target: self, action: "showSince:")
            innerView.addGestureRecognizer(pressRecognizer)
            
            // Create a since label that only shows up when the long press gesture is active
            sinceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            sinceLabel.text = self.since
            sinceLabel.font = UIFont(name: "Avenir-Book", size: 16)
            sinceLabel.textColor = UIColor.whiteColor()
            sinceLabel.alpha = 0
            sinceLabel.textAlignment = NSTextAlignment.Right
            self.addSubview(sinceLabel)
            
            self.addConstraint(NSLayoutConstraint(item: sinceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20))
            
            self.addConstraint(NSLayoutConstraint(item: sinceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        }
        
        var updatedRect = CGRectMake(container.frame.origin.x, container.frame.origin.y, 0, container.frame.size.height)
        innerView.frame = updatedRect
        
        // Create a label that contains the skill name
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Avenir-Book", size: 16)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.alpha = 0
        self.addSubview(nameLabel)
        
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20))
        
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // Create a label that shows the current percentage
        percentageLabel.text = String(format: "%i%%", percentage)
        percentageLabel.font = UIFont(name: "Avenir-Book", size: 16)
        percentageLabel.textColor = color
        percentageLabel.alpha = 0
        percentageLabel.textAlignment = NSTextAlignment.Right
        percentageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        innerView.addSubview(percentageLabel)
        
        innerView.addConstraint(NSLayoutConstraint(item: percentageLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 5))
        
        innerView.addConstraint(NSLayoutConstraint(item: percentageLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: innerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        
        innerView.layoutIfNeeded()
        self.layoutIfNeeded()
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func runAnimationWithDuration(duration: Double, delay : Double) {
        
        // Animate the progress bar and update the layout
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: { (
            ) -> Void in
            
            self.percentageLabel.alpha = 1
            self.nameLabel.alpha = 1
            
            let updatedRect = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y, (self.container.frame.size.width) * CGFloat(self.percentage!) / 100, self.container.frame.size.height)
            
            self.innerView.frame = updatedRect
            
            self.layoutIfNeeded()
            self.innerView.layoutIfNeeded()
            
        }) { (finished) -> Void in
            
        }
        
    }
    
    func showSince(sender: UILongPressGestureRecognizer) {
        // Only shows up when the gesture is still active
        if (sender.state == UIGestureRecognizerState.Began) {
            
            // Animates the innerView to the maximum and then shows up the since label
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: { (
                ) -> Void in
                
                self.percentageLabel.alpha = 0
                self.sinceLabel.alpha = 1
                
                let updatedRect = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y, self.container.frame.size.width, self.container.frame.size.height)
                
                self.innerView.frame = updatedRect
                
                self.layoutIfNeeded()
                self.innerView.layoutIfNeeded()
                
                }) { (finished) -> Void in
                    
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            // Reverses the animation and goes back to the previous state
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: { (
                ) -> Void in
                
                self.percentageLabel.alpha = 1
                self.sinceLabel.alpha = 0
                
                let updatedRect = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y, (self.container.frame.size.width) * CGFloat(self.percentage!) / 100, self.container.frame.size.height)
                
                self.innerView.frame = updatedRect
                
                self.layoutIfNeeded()
                self.innerView.layoutIfNeeded()
                
                }) { (finished) -> Void in
                    
            }
        }
        
    }
}
