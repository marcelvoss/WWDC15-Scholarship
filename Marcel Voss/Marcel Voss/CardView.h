//
//  CardView.h
//  Marcel Voss
//
//  Created by Marcel Voß on 15.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <StoreKit/StoreKit.h>

#import "MArcel_Voss-Swift.h"

typedef NS_ENUM(NSInteger, CardType) {
    CardTypeNormal,     // Standard/normal card type
    CardTypeWork,       // Special card type for work items that need a button and a date for each project
    CardTypeSpecial,    // Shows two different layouts based on the _cardID
};

@interface CardView : UIView

@property (nonatomic) CardType cardType;    // Contains the card type
@property (nonatomic) NSInteger cardID;     // The number of the card
@property (nonatomic) NSString *cardDate;   // Only important for cards of type CardTypeWork
@property (nonatomic) UIView *contentView;  // A view that can contain custom views
@property (nonatomic) UIImage *image;       // Contains an image, that can be shown in the bottom
@property (nonatomic) NSString *annotation; // Contains the description for images
@property (nonatomic) UILabel *descriptionLabel;

@property (nonatomic) InteractiveImageView *imageView; // The image view that will be shown if an image was assigned
@property (nonatomic) UIButton *bottomButton;          // Only important for cards of type CardTypeWork

// Custom init method to include a few parameters such as the cardType, the image, the annotation and the cardID
- (instancetype)initWithCardID:(NSInteger)cardID
                      cardType:(CardType)cardType
                         image:(UIImage *)image
                    annotation: (NSString *)annotation;

// Just a convenience method for calling the setupViews method directly
- (void)setupViews;

@end
