//
//  Constants.h
//  Marcel Voss
//
//  Created by Marcel Voß on 14.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSmallPhoneHeight 480

// Fonts
static NSString *kDefaultFont = @"Avenir-Roman";
static NSString *kDefaultFontBold = @"Avenir-Medium";
static NSString *kDefaultFontLight = @"Avenir-Light";
static NSString *kDefaultFontSuperBold = @"Avenir-Heavy";

// KVO Messages
static NSString *kMenuAboutButtonPressed = @"MenuAboutButtonWasPressed";
static NSString *kMenuWorkButtonPressed = @"MenuWorkButtonWasPressed";
static NSString *kMenuSkillsButtonPressed = @"MenuSkillsButtonWasPressed";
static NSString *kMenuEducationButtonPressed = @"MenuEducationButtonWasPressed";

#define TOWN_LATITUDE 53.5753200	    // Latitude of my hometown
#define TOWN_LONGTITUDE 10.0153400   // Longtitude of my hometown

@interface Constants : NSObject

@end
