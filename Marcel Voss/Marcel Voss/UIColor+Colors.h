//
//  UIColor+Colors.h
//  Grain
//
//  Created by Marcel Voß on 15.04.15.
//  Copyright (c) 2015 Marcel Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Colors)

+ (UIColor *)cancelButtonColor;

// Main Color
+ (UIColor *)mainOrangeColor;
+ (UIColor *)mainPurpleColor;
+ (UIColor *)mainGreenColor;
+ (UIColor *)mainBlueColor;

// Coding Color (based on GitHub's color
+ (UIColor *)swiftColor;
+ (UIColor *)objectColor;
+ (UIColor *)cssColor;
+ (UIColor *)cColor;
+ (UIColor *)pythonColor;
+ (UIColor *)htmlColor;
+ (UIColor *)rubyColor;

// Service colors
+ (UIColor *)twitterColor;
+ (UIColor *)githubColor;
+ (UIColor *)spotifyColor;

@end
