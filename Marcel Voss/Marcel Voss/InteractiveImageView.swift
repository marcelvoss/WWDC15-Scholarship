//
//  InteractiveImageView.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 18.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit

class InteractiveImageView: UIImageView {
    
    var theAnnotation : String?

    override init(image: UIImage) {
        super.init(image: image)
        
        self.userInteractionEnabled = true
        self.contentMode = UIViewContentMode.ScaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "showImageView")
        self.addGestureRecognizer(tapGesture)
        
    }
    
    init(image: UIImage, annotation: String?) {
        super.init(image: image)
        
        self.theAnnotation = annotation
        
        self.userInteractionEnabled = true
        self.contentMode = UIViewContentMode.ScaleAspectFill
        

        let tapGesture = UITapGestureRecognizer(target: self, action: "showImageView")
        self.addGestureRecognizer(tapGesture)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func showImageView() {
        var viewer = ImageViewer()
            
        if (self.theAnnotation != nil) {
            viewer.annotationLabel.text = self.theAnnotation!
        }
        
        if (self.image != nil) {
            viewer.show(self.image!)
        }
        
    }
    

}
