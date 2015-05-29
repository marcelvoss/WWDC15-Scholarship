//
//  AppViewer.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 18.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit
import StoreKit

class AppViewer: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SKStoreProductViewControllerDelegate {

    var collectionView : UICollectionView!
    var aWindow : UIWindow?
    
    var appName : String?
    var appIcon : UIImage?
    var screenshots: Array<UIImage>?
    var appID : NSNumber?
    var effectView = UIVisualEffectView()
    
    var collectionY : NSLayoutConstraint?
    
    init(appName: String, appIcon: UIImage, screenshots: Array<UIImage>, appID: NSNumber?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        aWindow = UIApplication.sharedApplication().keyWindow
        
        self.appName = appName
        self.appIcon = appIcon
        self.screenshots = screenshots
        self.appID = appID
        
        self.setupViews()
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath) as! UICollectionViewCell
        cell.userInteractionEnabled = true
        
        let imageView = InteractiveImageView(image: screenshots![indexPath.row])
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = screenshots![indexPath.row]
        imageView.frame = cell.bounds
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let collectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)
        
    }

    func show() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 1
            }) { (finished) -> Void in
        }
        
        UIView.animateWithDuration(0.4, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: nil, animations: { () -> Void in
            self.collectionY?.constant = -20
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            
        }
    }
    
    func hide(button : UIButton) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            self.collectionView.removeFromSuperview()
            
            self.appIcon = nil
            self.appName = nil
            
            self.removeFromSuperview()
        }
    }
    
    func setupViews() {
        aWindow?.addSubview(self)
        
        self.alpha = 0
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.frame
        self.addSubview(effectView)
        
        var closeButton  = UIButton()
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.addTarget(self, action: "hide:", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "CloseIcon"), forState: UIControlState.Normal)
        self.addSubview(closeButton)
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20))
        
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        
        
        var iconView = UIButton()
        iconView.setImage(appIcon, forState: UIControlState.Normal)
        iconView.userInteractionEnabled = false
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(iconView)
        
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -150))
        
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 100))
        
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 100))
        
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        if (appID != nil) {
    
            iconView.userInteractionEnabled = true
            iconView.addTarget(self, action: "storePressed", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        
        var appLabel = UILabel()
        appLabel.text = appName
        appLabel.textColor = UIColor.whiteColor()
        appLabel.font = UIFont(name: "Avenir-Medium", size: 25)
        appLabel.contentMode = UIViewContentMode.ScaleAspectFit
        appLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(appLabel)
        
        self.addConstraint(NSLayoutConstraint(item: appLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 3))
        
        self.addConstraint(NSLayoutConstraint(item: appLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(150, 250)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        self.addSubview(collectionView)
        
        
        collectionY = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: +self.frame.size.height)
        
        self.addConstraint(collectionY!)
        
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: self.frame.size.height / 2))
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.layoutIfNeeded()
    }
    
    func storePressed() {
        
        let theWindow = UIApplication.sharedApplication().delegate?.window
        let vc = theWindow!!.rootViewController
        
        let storeController = SKStoreProductViewController()
        storeController.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier : appID!]
        storeController.loadProductWithParameters(parameters, completionBlock: {result, error in
            
            if result {
                    vc!.presentViewController(storeController, animated: true, completion: nil)
                }
            
        })
        
    }
    
    // MARK: SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
            viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
