//
//  CardView.m
//  Marcel Voss
//
//  Created by Marcel Voß on 15.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

#import "CardView.h"
#import "Constants.h"

#import "UIColor+Colors.h"

@interface CardView ()
{
    CGFloat screenHeight; // Contains the screen height
    CGFloat screenWidth; // Constains the screen width
    
    NSArray *titles; // An array of all titles for the cards
    NSArray *descriptions; // An array of all descriptions for the cards
}

@end

@implementation CardView

- (instancetype)initWithCardID:(NSInteger)cardID
                      cardType:(CardType)cardType
                         image:(UIImage *)image
                    annotation:(NSString *)annotation
{
    self = [super init];
    if (self) {
        _cardID = cardID;
        _cardType = cardType;
        _image = image;
        _annotation = annotation;
        
        // Get the screen height and screen width
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.frame = CGRectMake(0, screenHeight * 2, screenWidth, screenHeight - 95);
        
        self.layer.cornerRadius = 12;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupArrays];
        [self setupViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Get the screen height and screen width
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.frame = CGRectMake(0, screenHeight * 2, screenWidth, screenHeight - 95);
        
        self.layer.cornerRadius = 12;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupArrays];
    }
    return self;
}

- (void)setupArrays
{
    // An array of all titles for the cards
    titles = @[@"The Beginning",
               @"First Steps",
               @"Life Changing",
               @"First Hackathon",
               @"A New Mindset",
               @"Interests",
               @"To Be Continued",
               @"Grain",
               @"MVDribbbleKit",
               @"Coding Languages",
               @"Experience",
               @"A normal student",
               @"College",
               @"Helping Others",
               @"Thanks!"
               ];
    
    // An array of all descriptions for the cards
    descriptions = @[@"I am a 17 years old high school student who lives in a small town in northern Germany with a population of only 20k people, called [REDACTED]. I developed an interest for technology and software very already. So, I started learning HTML when I was about 12 years old. When I got an iPod touch in 2009 I was amazed by it and that's basically where the story started.",
                     @"Soon I wanted to know how to build apps and how I can build my own ones.\n\nAfter my mom bought me my first Intel-based Mac in 2012, I also bought a book to learn Objective-C. I was fascinated by the language, by the APIs and by the possibilities. So, I spent more and more time coding my own apps and studying the language and the OS.",
                     @"Before I started coding I was very introverted but programming helped me with it. I talked to more people about topics that interest me. Due to this I actually met some of my best friends today. So, yes you could say that programming kind of changed my life.",
                     @"In September 2013 I took part in YRS Berlin which is a hackathon. I used my knowledge to build an iOS app that recommends you clothes to wear – based on the weather forecasts. Our project was called \"Kleiderfrosch\" and won in the category \"I Wish I'd Thought of That\". So, that was my first hackathon.",
                     @"Well, that was kind of a turning point for me. I even started to dream in code (especially when I had a really long day with a lot of code) but more important is that I also started to understand how a game or an app is made and how to break it. I acquired new ways of thinking which also help me in my daily life.\n\nSince then I always wanted to work for a tech company in Silicon Valley – preferably Apple.",
                     @"Even though I describe myself as a nerd, I am a normal teenager. I like rap music (see the playlist for more details), TV series (especially Game of Thrones), video games and I like to meet my friends.\n\nApart from these things, I am also interested in politics, democracy, equality for everyone and learning things.\n\nI want to leave a better world.",
                     @"It won't stop here and I won't stop learning neither. So, for example I started learning Swift last year immediately after WWDC and now I slowly begin to use it in production. My upcoming app, Grain, and an upcoming open source library are completely written in Swift.\n\nI can't wait to see what future brings!",
                     @"Grain is the perfect app for friends of analog photography. It manages all your developer recipies (including ISOs, films and developers) and provides tools to improve the development process. Make the most out of your photos!\n\nGrain will be launching soon!",
                     @"This is my most recent and probably also my best open source project so far. It is a powerful, elegant and modern wrapper for the Dribbble API (which is a site where designers can share their work). It also makes it a lot easier to acccess Dribbble within your apps.\n\nBy the way, there are three apps on the App Store at the moment that use my wrapper which makes me extremly proud.",
                     @"A list of programming languages I know:",
                     @"Apart from the programming languages, I am also familiar with things like Git.\n\nBecause I already built several apps and libraries that interact with an API of some kind I'm pretty proficient at building networking apps. Nonetheless I really enjoy frontend work too.\n\nMoreover I love to create custom UIs and to experiment with new concepts and ideas that come to my mind.",
                     @"I am a tenth grader going to Gymnasium [REDACTED] (Gymasium means high school in German). My favorite subjects are English, History, Politics and German. Unfortunately, there aren't any CS classes at my school, so I had to learn how to code on my own.\n\nIn addition to that, I am trilingual and in German and English and currently learning Russian.",
                     @"I expect to graduate in 2017. After graduation I want to go to college and study Law or Computer Science (I would study both if I could) but there are still 2 years left until I have to decide that – luckily.\n\nI would love to go to Stanford later which is, in my opinion, the best and most inspiring college in the world.",
                     @"About two months ago a teacher asked me if I could tell other interested students about programming. So, in July I will teach an entire week the basics of coding in Python and C at my school. I can't wait to show other students how much fun it is to create software and to share my knowledge.\n\nI really hope that I can motivate them to continue coding, even after the week.",
                     @"So, that was me and my story.\nI hope we will see us at WWDC.",
                     ];
}

- (void)setupViews
{
    // Get the card height and the card width
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;

    // Title Label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:kDefaultFontBold size:30];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    
    // Description Label
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentJustified;
    _descriptionLabel.font = [UIFont fontWithName:kDefaultFont size:17];
    _descriptionLabel.textColor = [UIColor blackColor];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_descriptionLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width - 40]];
    
    if (_cardID == 14) {
        // Change the layout if card is the "Thanks" card
        // Special layout adjustments
        
        titleLabel.text = titles[_cardID];
        _descriptionLabel.text = descriptions[_cardID];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        
        // JUST MAKING SOME OF OF MYSELF :P
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(width / 2 - 65, height / 2 -130, 130, 130)];
        imageView.image = [UIImage imageNamed:@"MeHappy"];
        imageView.layer.cornerRadius = imageView.frame.size.height / 2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 0.6;
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
            
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    } else {
        // Set titleLabel text from object at index of cardID in the titles array
        titleLabel.text = titles[_cardID];
        _descriptionLabel.text = descriptions[_cardID];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width - 50]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
    }
    
    // Create the contentView with the remaining space on the card
    // Important: this is dynamic and depends on the size of the descriptionLabel
    [self layoutIfNeeded];
    CGFloat descriptionY = CGRectGetMaxY(_descriptionLabel.frame);
    CGFloat remainingSpace = self.frame.size.height - descriptionY + 20;
    
    _contentView = [[UIView alloc]
                    initWithFrame:CGRectMake(0, descriptionY - 20, self.frame.size.width, remainingSpace)];
    [self addSubview:_contentView];
    
    
    // Corner View
    // Round bottom corners
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(12.0, 12.0)];
        
    // Apply mask
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    _contentView.layer.mask = maskLayer;
    
    if (_image ) {
        if (_cardID != 0) {
            // Add image view for every card, that has a non-nil _image property
            _imageView = [[InteractiveImageView alloc] initWithImage:_image annotation:_annotation];
            _imageView.frame = CGRectMake(0, self.contentView.frame.size.height - 140, self.frame.size.width, 140);
            _imageView.userInteractionEnabled = YES;
            [self.contentView addSubview:_imageView];
            
            // Gradient for fading out the image view into the white background
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = _imageView.bounds;
            gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
            gradientLayer.startPoint = CGPointMake(0.0f, 1.0f);
            gradientLayer.endPoint = CGPointMake(0.0f, 0.1f);
            _imageView.layer.mask = gradientLayer;
        }
    }
    
    if (_cardType == CardTypeWork || _cardID == 5) {
        
        // Work Cards
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont fontWithName:kDefaultFont size:15];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:dateLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
        
        // Add the date to every card
        if (_cardID == 7) {
            dateLabel.text = @"2015";
        } else if (_cardID == 8) {
            dateLabel.text = @"2014";
        }
        
        // Add button for more information
        _bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomButton.backgroundColor = [UIColor mainBlueColor];
        _bottomButton.titleLabel.font = [UIFont fontWithName:kDefaultFont size:16];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _bottomButton.layer.cornerRadius = 10;
        [self.contentView addSubview:_bottomButton];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-30]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:44]];
    }
    
}

@end
