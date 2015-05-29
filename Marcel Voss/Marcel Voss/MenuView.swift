//
//  MenuView.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 17.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var aWindow : UIWindow?
    
    let aboutButton = UIButton()
    let workButton = UIButton()
    let skillsButton = UIButton()
    let educationButton = UIButton()
    
    var aboutConstraint : NSLayoutConstraint?
    var workConstraint : NSLayoutConstraint?
    var skillsConstraint : NSLayoutConstraint?
    var educationConstraint : NSLayoutConstraint?
    
    var effectView = UIVisualEffectView()
    
    var width : CGFloat?
    var height : CGFloat?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        aWindow = UIApplication.sharedApplication().keyWindow
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func show() {
        self.setupViews()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 1
            self.effectView.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.aboutConstraint?.constant = 0
            self.layoutIfNeeded()
        }) { (finished) -> Void in
                
        }
            
        UIView.animateWithDuration(0.2, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.workConstraint?.constant = 0
            self.layoutIfNeeded()
            }) { (finished) -> Void in
                    
        }
            
        UIView.animateWithDuration(0.2, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: nil, animations: { () -> Void in
            self.skillsConstraint?.constant = 0
            self.layoutIfNeeded()
            }) { (finished) -> Void in
                    
        }
            
        UIView.animateWithDuration(0.2, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.educationConstraint?.constant = 0
            self.layoutIfNeeded()
            }) { (finished) -> Void in
                
        }
    }

    func hide() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func setupViews() {
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.frame
        effectView.alpha = 0
        self.addSubview(effectView)

        self.width = UIScreen.mainScreen().bounds.size.width
        self.height = UIScreen.mainScreen().bounds.size.height
        
        self.userInteractionEnabled = true
        self.alpha = 0
        
        aWindow?.addSubview(self)
        
        aboutButton.setImage(UIImage(named: "AboutItem"), forState: UIControlState.Normal)
        aboutButton.tag = 0
        aboutButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        aboutButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(aboutButton)
        
        aboutConstraint = NSLayoutConstraint(item: aboutButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -width!)
        
        self.addConstraint(aboutConstraint!)
        
        self.addConstraint(NSLayoutConstraint(item: aboutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -95))
        
        
        self.addConstraint(NSLayoutConstraint(item: aboutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 80))
        
        self.addConstraint(NSLayoutConstraint(item: aboutButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 80))
        
        
        workButton.setImage(UIImage(named: "WorkItem"), forState: UIControlState.Normal)
        workButton.tag = 1
        workButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        workButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(workButton)
        
        self.addConstraint(NSLayoutConstraint(item: workButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -5 ))
        
        workConstraint = NSLayoutConstraint(item: workButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -width!)
        
        self.addConstraint(workConstraint!)
        
        self.addConstraint(NSLayoutConstraint(item: workButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 80))
        
        self.addConstraint(NSLayoutConstraint(item: workButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 80))
        
    
        skillsButton.setImage(UIImage(named: "SkillsItem"), forState: UIControlState.Normal)
        skillsButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        skillsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        skillsButton.tag = 2
        self.addSubview(skillsButton)
        
        skillsConstraint = NSLayoutConstraint(item: skillsButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -width!)
        
        self.addConstraint(skillsConstraint!)
        
        self.addConstraint(NSLayoutConstraint(item: skillsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 5))
        

        self.addConstraint(NSLayoutConstraint(item: skillsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 80))
        
        self.addConstraint(NSLayoutConstraint(item: skillsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 80))
        
        
        educationButton.setImage(UIImage(named: "EducationItem"), forState: UIControlState.Normal)
        educationButton.tag = 3
        educationButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        educationButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(educationButton)
        
        educationConstraint = NSLayoutConstraint(item: educationButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -width!)
        
        self.addConstraint(educationConstraint!)
        
         self.addConstraint(NSLayoutConstraint(item: educationButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 95))
        
        self.addConstraint(NSLayoutConstraint(item: educationButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 80))
        
        self.addConstraint(NSLayoutConstraint(item: educationButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 80))
        
        self.layoutIfNeeded()

    }
    
    func buttonPressed(sender: UIButton!) {
        if (sender.tag == 0) {
            NSNotificationCenter.defaultCenter().postNotificationName("MenuAboutButtonWasPressed", object:nil)
        } else if (sender.tag == 1) {
            NSNotificationCenter.defaultCenter().postNotificationName("MenuWorkButtonWasPressed", object:nil)
        } else if (sender.tag == 2) {
            NSNotificationCenter.defaultCenter().postNotificationName("MenuSkillsButtonWasPressed", object:nil)
        } else if (sender.tag == 3) {
            NSNotificationCenter.defaultCenter().postNotificationName("MenuEducationButtonWasPressed", object:nil)
        }
        self.hide()
    }
    
}
