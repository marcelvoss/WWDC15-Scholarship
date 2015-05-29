//
//  MainViewController.m
//  Marcel Voss
//
//  Created by Marcel Voß on 14.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "CardView.h"
#import "UIColor+Colors.h"

#import "Marcel_Voss-Swift.h"

static const CGFloat __maximumDismissDelay = 0.5f;
static const CGFloat __velocityFactor = 1.0f;
static const CGFloat __angularVelocityFactor = 1.0f;
static const CGFloat __minimumVelocityRequiredForPush = 50.0f;

@interface MainViewController () <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>
{
    InteractiveImageView *avatarImageView;
    UIImageView *backgroundImageView;
    UILabel *quoteLabel;
    UILabel *authorLabel;
    UIImageView *backgroundOverlay;
    MenuView *menu;
    UIImageView *arrowImageView;
    CardView *cardView;
    UIButton *menuButton;
    UIView *overlay;
    
    UILabel *helloLabel;
    UILabel *subtitleLabel;
    
    // Constraints
    NSLayoutConstraint *cardYConstraint;
    NSArray *quotesArray;  // An array that contains all quotes
    
    CardView *card;
    
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *cardsArray;
    
    int currentCard; // An integer variable that stores the current card index
    UIImage *mapShot;
    
    NSString *annotationText;

}

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UISnapBehavior *snapBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) UIAttachmentBehavior *panAttachmentBehavior;

@end

@implementation MainViewController

#pragma mark - Application Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // An array that contains all cards
    cardsArray = [NSMutableArray array];

    // Retrieve quotes from JSON file and assign them to quotesArray
    quotesArray = [NSArrayUtilities arrayForJSON:@"Data"];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Assign sizes to variables
    // Just for convenience reasons
    width = [[UIScreen mainScreen] bounds].size.width;     // screen width
    height = [[UIScreen mainScreen] bounds].size.height;   // screen height
    
    // Scroll View
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(width, height * 2);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.tag = 0;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    // Background Image View
    // Containts an image that is shown on the entire scroll view
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background1"]];
    backgroundImageView.frame = CGRectMake(0, 0, width, height * 2);
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.userInteractionEnabled = YES;
    [scrollView addSubview:backgroundImageView];

    // Background blur with UIVisualEffectView and UIBlurEffect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectViewBlurred = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectViewBlurred.frame = [backgroundImageView bounds];
    [backgroundImageView addSubview:visualEffectViewBlurred];
    
    // Avatar Image View
    avatarImageView = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"MeAvatar"] annotation:@"That's me and, as you can probably see, I hate to take photos of myself."];
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 2.0;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 100 / 2;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:avatarImageView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    

    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-height + 150]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
    
    // Name Label
    helloLabel = [UILabel new];
    helloLabel.text = @"Marcel Voss";
    helloLabel.alpha = 0;
    helloLabel.textColor = [UIColor whiteColor];
    helloLabel.textAlignment = NSTextAlignmentCenter;
    helloLabel.font = [UIFont fontWithName:kDefaultFontBold size:28];
    helloLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:helloLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:helloLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:helloLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    
    // Subtitle Label
    subtitleLabel = [UILabel new];
    subtitleLabel.text = @"Student at day, iOS developer at night.";
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont fontWithName:kDefaultFontBold size:17];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.numberOfLines = 2;
    subtitleLabel.alpha = 0;
    [backgroundImageView addSubview:subtitleLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-60]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:helloLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    // Scroll Up Label
    UILabel *scrollUpLabel = [UILabel new];
    scrollUpLabel.text = @"Swipe Up";
    scrollUpLabel.textColor = [UIColor whiteColor];
    scrollUpLabel.textAlignment = NSTextAlignmentCenter;
    scrollUpLabel.font = [UIFont fontWithName:kDefaultFont size:15];
    scrollUpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:scrollUpLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:scrollUpLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:15]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:scrollUpLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:(height * 1) - 25]];
    
    // Arrow Image View
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIcon"]];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    [backgroundImageView addSubview:arrowImageView];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scrollUpLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-15]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:scrollUpLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:18]];
    
    // Retrieves a random object from the quotesArray
    NSDictionary *myQuote = [NSArrayUtilities randomObject:quotesArray];
    
    // Quote Label
    quoteLabel = [UILabel new];
    quoteLabel.font = [UIFont fontWithName:kDefaultFontLight size:15];
    quoteLabel.textAlignment = NSTextAlignmentCenter;
    quoteLabel.textColor = [UIColor whiteColor];
    quoteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    quoteLabel.numberOfLines = 0;
    [self setQuoteToLabelFromDictionary:myQuote];
    [backgroundImageView addSubview:quoteLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:height - 130]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quoteLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-80]];
    
    // Quotes Headline
    UILabel *quotesHeadline = [UILabel new];
    quotesHeadline.text = @"My Favorite Quotes";
    quotesHeadline.font = [UIFont fontWithName:kDefaultFontBold size:15];
    quotesHeadline.translatesAutoresizingMaskIntoConstraints = NO;
    quotesHeadline.textColor = [UIColor whiteColor];
    [backgroundImageView addSubview:quotesHeadline];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quotesHeadline attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:quoteLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quotesHeadline attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:quoteLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:quotesHeadline attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    // Author Label
    authorLabel = [UILabel new];
    authorLabel.font = [UIFont fontWithName:kDefaultFontBold size:14];
    authorLabel.textAlignment = NSTextAlignmentRight;
    authorLabel.textColor = [UIColor whiteColor];
    [self setQuoteToLabelFromDictionary:myQuote];
    authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundImageView addSubview:authorLabel];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:quoteLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:quoteLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:authorLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    
    // Menu Button
    menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton.titleLabel setText:@"About Me"];
    menuButton.titleLabel.font = [UIFont fontWithName:kDefaultFont size:30];
    menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [menuButton addTarget:self action:@selector(menuItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:menuButton];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:menuButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:height + 30]];
    
    
    // Help Button
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    helpButton.tintColor = [UIColor whiteColor];
    [helpButton setImage:[UIImage imageNamed:@"HelpIcon"] forState:UIControlStateNormal];
    helpButton.translatesAutoresizingMaskIntoConstraints = NO;
    helpButton.userInteractionEnabled = YES;
    [helpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:helpButton];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:helpButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];
    
    [backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:helpButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:menuButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    
    // KVO
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWorkButtonPressed:)
                                                 name:kMenuWorkButtonPressed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuAboutButtonPressed:)
                                                 name:kMenuAboutButtonPressed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSkillsButtonPressed:)
                                                 name:kMenuSkillsButtonPressed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEducationButtonPressed:)
                                                 name:kMenuEducationButtonPressed object:nil];
    
    
    // Display Size Warning
    // Unfortunately required because there wasn't enough time to optimize the UI for 3.5" inch screens :(
    if ([[UIScreen mainScreen] bounds].size.height < 568) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Even though my app works on the iPhone 4S, I highly recommend using an iPhone 5 or newer." preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        // Workaround for an iOS bug that doesn't show the alert controller
        // Please see the following radar for more information: rdar://17742017
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }
    
    // Set default view
    [self menuAboutButtonPressed:nil];
    [self setupAnimation];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Dragging

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint boxLocation = [gestureRecognizer locationInView:card];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.snapBehavior];
        [self.animator removeBehavior:self.pushBehavior];
        
        UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(card.bounds), boxLocation.y - CGRectGetMidY(card.bounds));
        self.panAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:card offsetFromCenter:centerOffset attachedToAnchor:location];
        _panAttachmentBehavior.frequency = 0;
        [self.animator addBehavior:self.panAttachmentBehavior];
        [self.animator addBehavior:self.itemBehavior];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        self.panAttachmentBehavior.anchorPoint = location;
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.panAttachmentBehavior];
        
        
        CGFloat deviceVelocityScale = 1.0f;
        CGFloat deviceAngularScale = 1.0f;
        
        CGFloat deviceDismissDelay =  1.0f;
        CGPoint velocity = [gestureRecognizer velocityInView:self.view];
        CGFloat velocityAdjust = 10.0f * deviceVelocityScale;
        
        
        if (fabs(velocity.x / velocityAdjust) > __minimumVelocityRequiredForPush || fabs(velocity.y / velocityAdjust) > __minimumVelocityRequiredForPush) {
            UIOffset offsetFromCenter = UIOffsetMake(boxLocation.x - CGRectGetMidX(card.bounds), boxLocation.y - CGRectGetMidY(card.bounds));
            CGFloat radius = sqrtf(powf(offsetFromCenter.horizontal, 2.0f) + powf(offsetFromCenter.vertical, 2.0f));
            CGFloat pushVelocity = sqrtf(powf(velocity.x, 2.0f) + powf(velocity.y, 2.0f));
            
            CGFloat velocityAngle = atan2f(velocity.y, velocity.x);
            CGFloat locationAngle = atan2f(offsetFromCenter.vertical, offsetFromCenter.horizontal);
            if (locationAngle > 0) {
                locationAngle -= M_PI * 2;
            }
            
            CGFloat angle = fabsf(fabsf((float)velocityAngle) - fabsf((float)locationAngle));
            CGFloat angularVelocity = fabsf((fabsf((float)pushVelocity) * sinf(angle)) / fabsf((float)radius));

            CGFloat direction = (location.x < self.view.center.x) ? -1.0f : 1.0f;
            if (velocity.y < 0) { direction *= -1; }
            
            CGFloat xRatioFromCenter = fabsf((float)offsetFromCenter.horizontal) / (CGRectGetWidth(card.frame) / 2.0f);
            CGFloat yRatioFromCetner = fabsf((float)offsetFromCenter.vertical) / (CGRectGetHeight(card.frame) / 2.0f);
            
            angularVelocity *= deviceAngularScale;
            angularVelocity *= ((xRatioFromCenter + yRatioFromCetner) / 2.0f);
            
            [self.itemBehavior addAngularVelocity:angularVelocity * __angularVelocityFactor * direction forItem:card];
            [self.animator addBehavior:self.pushBehavior];
            self.pushBehavior.pushDirection = CGVectorMake((velocity.x / velocityAdjust) * __velocityFactor, (velocity.y / velocityAdjust) * __velocityFactor);
            self.pushBehavior.active = YES;

            CGFloat delay = __maximumDismissDelay - (pushVelocity / 10000.0f);
            [self performSelector:@selector(dismissAfterPush) withObject:nil afterDelay:(delay * deviceDismissDelay) * __velocityFactor];
        }
        else {
            [self returnToCenter];
        }
    }
}

- (void)dismissAfterPush
{
    // Increment the current card index
    currentCard++;
    
    // Checks if currentCard has an higher value than the last object in the cards array
    // Sets the currentCard index back to 0 and starts from the beginning
    if (currentCard > [cardsArray indexOfObject:cardsArray.lastObject]) {
        currentCard = 0;
        
        // Switch to next category
        if ([menuButton.titleLabel.text isEqualToString:@"Work"]) {
            [self menuSkillsButtonPressed:nil];
        } else if ([menuButton.titleLabel.text isEqualToString:@"About Me"]) {
            [self menuWorkButtonPressed:nil];
        } else if ([menuButton.titleLabel.text isEqualToString:@"Skills"]) {
            [self menuEducationButtonPressed:nil];
        } else if ([menuButton.titleLabel.text isEqualToString:@"Education"]) {
            [self finalCards];
        } else if ([menuButton.titleLabel.text isEqualToString:@"The End"]) {
            [self menuAboutButtonPressed:nil];
        }

    } else {
        // Show the next card
        [self springCard:cardsArray[currentCard]];
    }
}

- (void)returnToCenter
{
    if (self.animator) {
        [self.animator removeAllBehaviors];
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        card.transform = CGAffineTransformIdentity;
        card.frame = CGRectMake(0, height + 95, width, height - 95);
    } completion:nil];
}

#pragma mark - Menu Methods

- (void)menuAboutButtonPressed:(UIButton *)button
{
    [self hideCard];
    [cardsArray removeAllObjects];
    
    currentCard = 0;
    [menuButton setTitle:@"About Me" forState:UIControlStateNormal];
    
    CardView *card1;
    
    // Only take snapshot if mapShot is nil
    if (mapShot) {
        
        // Create the first card and add it to the cards array
        card1 = [[CardView alloc] initWithCardID:0 cardType:CardTypeNormal image:nil annotation:nil];
        [cardsArray addObject:card1];
        
        // Create the image view, that contains the mapShot image
        UIImageView *mapImageView = [[UIImageView alloc] initWithImage:mapShot];
        mapImageView.userInteractionEnabled = YES;
        mapImageView.frame = CGRectMake(0, card1.contentView.frame.size.height - 140, card1.frame.size.width, 140);
        [card1.contentView addSubview:mapImageView];
        
        // Add a gradient to the image view to fade the image out
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = mapImageView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0.0f, 1.0f);
        gradientLayer.endPoint = CGPointMake(0.0f, 0.04f);
        mapImageView.layer.mask = gradientLayer;
        
        // Add a gesture recognizer to the image view to make it clickable
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapPressed:)];
        [mapImageView addGestureRecognizer:tapGesture];
    } else {
        // Create the first card and add it to the cards array
        card1 = [[CardView alloc] initWithCardID:0 cardType:CardTypeNormal image:nil annotation:nil];
        [cardsArray addObject:card1];
        
        // Set the snapshot options
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(TOWN_LATITUDE, TOWN_LONGTITUDE), MKCoordinateSpanMake(0.05, 0.05));
        options.size = CGSizeMake(self.view.frame.size.width, 140);
        options.scale = [[UIScreen mainScreen] scale];
        
        // Retrieve the actual map snapshot
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (error) {
                
                // Shows a UIAlertController with the error description if the map couldn't be retrieved
                UIAlertController *mapAlert = [UIAlertController alertControllerWithTitle:@"Ooops" message:[NSString stringWithFormat:@"I couldn't load the map for some reason. (Error: %@", error.description] preferredStyle:UIAlertControllerStyleAlert];
                
                [mapAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [mapAlert dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [self presentViewController:mapAlert animated:YES completion:nil];
                
                return;
            } else {
                mapShot = snapshot.image;
                
                // Create the image view, that contains the mapShot image
                UIImageView *mapImageView = [[UIImageView alloc] initWithImage:mapShot];
                mapImageView.alpha = 0;
                mapImageView.userInteractionEnabled = YES;
                mapImageView.frame = CGRectMake(0, card1.contentView.frame.size.height - 140, card1.frame.size.width, 140);
                [card1.contentView addSubview:mapImageView];
                
                // Add a gradient to the image view to fade the image out
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = mapImageView.bounds;
                gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
                gradientLayer.startPoint = CGPointMake(0.0f, 1.0f);
                gradientLayer.endPoint = CGPointMake(0.0f, 0.04f);
                mapImageView.layer.mask = gradientLayer;
                // Add a gesture recognizer to the image view to make it clickable
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapPressed:)];
                [mapImageView addGestureRecognizer:tapGesture];
                
                // Animate the alpha value of the mapImageView
                [UIView animateWithDuration:0.4 animations:^{
                    mapImageView .alpha = 1;
                }];
            }
        }];
    }
    
    CardView *card2 = [[CardView alloc] initWithCardID:1 cardType:CardTypeNormal image:[UIImage imageNamed:@"BooksPhoto"]  annotation:@"Some of my favorite books about programming (the last one is the book I've learned Objective-C with back in 2012)."];
    [cardsArray addObject:card2];
    
    CardView *card3 = [[CardView alloc] initWithCardID:2 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card3];
    
    CardView *card4 = [[CardView alloc] initWithCardID:3 cardType:CardTypeNormal image:[UIImage imageNamed:@"MeJugendHackt"]annotation:@"In this photo I'm telling a couple of other hackers about my progress. By the way, I am the guy in the blue tee."];
    [cardsArray addObject:card4];
    
    CardView *card5 = [[CardView alloc] initWithCardID:4 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card5];
    
    CardView *card6 = [[CardView alloc] initWithCardID:5 cardType:CardTypeNormal image:nil annotation:nil];
    [card6.bottomButton setBackgroundColor:[UIColor spotifyColor]];
    [card6.bottomButton setTitle:@"Music Playlist on Spotify" forState:UIControlStateNormal];
    [card6.bottomButton addTarget:self action:@selector(openSpotify:) forControlEvents:UIControlEventTouchUpInside];
    [cardsArray addObject:card6];
    
    CardView *card7 = [[CardView alloc] initWithCardID:6 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card7];
    
    [self springCard:card1];
}

- (void)menuWorkButtonPressed:(UIButton *)button
{
    [self hideCard];
    [cardsArray removeAllObjects];
    
    currentCard = 0;
    [menuButton setTitle:@"Work" forState:UIControlStateNormal];
    
    // Grain
    CardView *card1 = [[CardView alloc] initWithCardID:7 cardType:CardTypeWork image:nil annotation:nil];
    card1.bottomButton.backgroundColor = [UIColor mainBlueColor];
    card1.bottomButton.tag = 0;
    [card1.bottomButton addTarget:self action:@selector(showAppViewer:)
                 forControlEvents:UIControlEventTouchUpInside];
    [card1.bottomButton setTitle:@"More Information" forState:UIControlStateNormal];
    [cardsArray addObject:card1];
    
    // MVDribbbleKit
    CardView *card3 = [[CardView alloc] initWithCardID:8 cardType:CardTypeWork image:nil annotation:nil];
    card3.bottomButton.backgroundColor = [UIColor mainPurpleColor];
    [card3.bottomButton setTitle:@"View on GitHub" forState:UIControlStateNormal];
    [card3.bottomButton addTarget:self action:@selector(dribbbleButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    [cardsArray addObject:card3];
    
    [self springCard:card1];
}

- (void)menuSkillsButtonPressed:(UIButton *)button
{
    // TODO: Interface improvements
    
    [self hideCard];
    [cardsArray removeAllObjects];
    
    currentCard = 0;
    [menuButton setTitle:@"Skills" forState:UIControlStateNormal];
    
    CardView *card1 = [[CardView alloc] initWithCardID:9 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card1];
    
    CardView *card2 = [[CardView alloc] initWithCardID:10 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card2];
    
    [self springCard:card1];
}

- (void)menuEducationButtonPressed:(UIButton *)button
{
    [self hideCard];
    [cardsArray removeAllObjects];
    
    currentCard = 0;
    [menuButton setTitle:@"Education" forState:UIControlStateNormal];
    
    CardView *card1 = [[CardView alloc] initWithCardID:11 cardType:CardTypeNormal image:[UIImage imageNamed:@"MeSchool"] annotation:@"Yep, that's my school."];
    [cardsArray addObject:card1];
    
    CardView *card2 = [[CardView alloc] initWithCardID:12 cardType:CardTypeNormal image:[UIImage imageNamed:@"StanfordPhoto"] annotation:@"The most inpiring college in the world – Stanford <3"];
    [cardsArray addObject:card2];

    CardView *card3 = [[CardView alloc] initWithCardID:13 cardType:CardTypeNormal image:nil annotation:nil];
    [cardsArray addObject:card3];
    
    [self springCard:card1];
}

- (void)finalCards
{
    [self hideCard];
    [cardsArray removeAllObjects];
    
    currentCard = 0;
    [menuButton setTitle:@"The End" forState:UIControlStateNormal];
    
    CardView *card1 = [[CardView alloc] initWithCardID:14 cardType:CardTypeSpecial image:nil annotation:nil];
    [cardsArray addObject:card1];

    
    [self springCard:card1];
}

#pragma mark - Card Methods

- (void)dribbbleButtonPressed:(id)sender
{
    // Opens the given GitHub URL in Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/marcelvoss/mvdribbblekit"]];
}

- (void)openSpotify:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://open.spotify.com/user/uimarcel/playlist/3dZQQCOT8d9podCrPJvDXQ"]];
}

- (void)showAppViewer:(UIButton *)sender
{
    if (sender.tag == 0) {
        // Grain
        AppViewer *viewer = [[AppViewer alloc] initWithAppName:@"Grain" appIcon:[UIImage imageNamed:@"GrainIcon"] screenshots:@[[UIImage imageNamed:@"GrainScreenshot1"], [UIImage imageNamed:@"GrainScreenshot2"], [UIImage imageNamed:@"GrainScreenshot3"], [UIImage imageNamed:@"GrainScreenshot4"]] appID:nil];
        [viewer show];
    }
}

#pragma mark - Helpers

- (void)addDynamicsToCard:(CardView *)aCard
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panRecognizer.delegate = self;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
    
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:aCard snapToPoint:self.view.center];
    self.snapBehavior.damping = 1.0f;
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[aCard] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.angle = 0.0f;
    self.pushBehavior.magnitude = 0.0f;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[aCard]];
    self.itemBehavior.elasticity = 0.0f;
    self.itemBehavior.friction = 0.2f;
    self.itemBehavior.allowsRotation = YES;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.resistance = 0.6;
    
    [aCard addGestureRecognizer:self.panRecognizer];
}

#pragma mark - Gesture Recognizers

- (void)menuItemPressed:(UITapGestureRecognizer *)tap
{
    // Menu View
    menu = [[MenuView alloc] init];
    [menu show];
        
    // Add tap gesture to close menu view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(hideMenu:)];
    [menu addGestureRecognizer:tapGesture];
}

- (void)helpPressed:(id)sender
{
    // Help Overlay
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    overlay = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0;
    [window addSubview:overlay];
    
    // Menu Description
    UILabel *menuDescription= [UILabel new];
    menuDescription.text = @"Tap on this headline to enter the menu. This will give you an overview of the available cards.";
    menuDescription.font = [UIFont fontWithName:kDefaultFont size:16];
    menuDescription.textAlignment = NSTextAlignmentCenter;
    menuDescription.textColor = [UIColor whiteColor];
    menuDescription.numberOfLines = 0;
    menuDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [overlay addSubview:menuDescription];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:menuDescription attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:menuDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeTop multiplier:1.0 constant:120]];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:menuDescription attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-90]];
    
    // Card Description
    UILabel *cardDescription= [UILabel new];
    cardDescription.text = @"Flick this card in any direction you want, to dismiss it and to show the next one.";
    cardDescription.font = [UIFont fontWithName:kDefaultFont size:16];
    cardDescription.textAlignment = NSTextAlignmentCenter;
    cardDescription.textColor = [UIColor whiteColor];
    cardDescription.numberOfLines = 0;
    cardDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [overlay addSubview:cardDescription];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:cardDescription attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:cardDescription attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:100]];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:cardDescription attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-90]];
    
    // Close Description
    UILabel *closeLabel = [UILabel new];
    closeLabel.text = @"Tap anywhere to dismiss this window.";
    closeLabel.font = [UIFont fontWithName:kDefaultFontLight size:14];
    closeLabel.textAlignment = NSTextAlignmentCenter;
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [overlay addSubview:closeLabel];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:closeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15]];
    
    [overlay addConstraint:[NSLayoutConstraint constraintWithItem:closeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    // Add a tap gesture recognizer to the help overlay to dismiss it by simply tapping
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(hideHelpOverlay:)];
    [overlay addGestureRecognizer:tap];
    
    // Change the alpha value of the overlay to a half-transparent state
    [UIView animateWithDuration:0.3 animations:^{
        overlay.alpha = 0.8;
    }];
}

- (void)hideMenu:(UITapGestureRecognizer *)tapGesture
{
    [menu hide];
}

- (void)hideHelpOverlay:(UITapGestureRecognizer *)recognizer
{
    // Change the alpha value of the overlay back to 0 and then remove it from super view
    [UIView animateWithDuration:0.3 animations:^{
        overlay.alpha = 0;
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
    }];
}

#pragma mark - Viewers

- (void)mapPressed:(UIGestureRecognizer *)sender
{
    MapViewer *viewer = [[MapViewer alloc] init];
    
    // Initialize map view
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    
    MKCoordinateRegion theRegion;
    
    // Important: not actual coordinates. This actually refers to the place I live at the moment.
    theRegion.center.latitude = TOWN_LATITUDE;
    theRegion.center.longitude = TOWN_LONGTITUDE;
    theRegion.span.latitudeDelta = 0.05f;
    theRegion.span.longitudeDelta = 0.05f;
    
    mapView.region = theRegion;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(TOWN_LATITUDE, TOWN_LONGTITUDE);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"My Hometown";
    [mapView addAnnotation:annotation];
    
    viewer.mapView = mapView;
    [viewer show];
}

#pragma mark - Quotes

- (void)setQuoteToLabelFromDictionary:(NSDictionary *)quoteDictionary
{
    // Retrieves objects from the quote array by their keys and assigns them to two variables
    NSString *author = quoteDictionary[@"author"];
    NSString *quote = quoteDictionary[@"quote"];
    
    quoteLabel.text = quote;    // Assign to quoteLabel
    authorLabel.text = author;  // Assign to authorLabel
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // Vibrate the device
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // Gets new random quote and calls setQuoteToLabelFromDictionary to assign the values
        NSDictionary *newQuote = [NSArrayUtilities randomObject:quotesArray];
        [self setQuoteToLabelFromDictionary:newQuote];
    }
}

#pragma mark - Animations

- (void)springCard:(CardView *)aCard
{
    [card removeFromSuperview];
    card = aCard;
    
    [self addDynamicsToCard:aCard];
    
    [backgroundImageView addSubview:aCard];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        aCard.frame = CGRectMake(0, height + 95, width, height - 95);
        
        // Checks if the card id is equal to the skills card id
        if (card.cardID == 9) {
            
            // Hide the description label, which isn't needed for this card
            card.descriptionLabel.hidden = YES;
            
            // Initial position on the y-axis
            CGFloat originY = card.frame.size.height / 2;
            
            // Objective-C bar
            SkillView *s2 = [[SkillView alloc] initWithName:@"Objective-C" percentage:85 color:[UIColor objectColor] since:@"Since 2012" frame:CGRectMake(20, originY + 150, width, 65)];
            [s2 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s2];
            
            // C bar
            SkillView *s3 = [[SkillView alloc] initWithName:@"C" percentage:70 color:[UIColor cColor] since:@"Since 2011" frame:CGRectMake(20, originY + 100, width, 65)];
            [s3 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s3];
            
            // Python bar
            SkillView *s4 = [[SkillView alloc] initWithName:@"Python" percentage:60 color:[UIColor pythonColor] since:@"Since 2013" frame:CGRectMake(20, originY + 50, width, 65)];
            [s4 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s4];
            
            // Swift bar
            SkillView *s = [[SkillView alloc] initWithName:@"Swift" percentage:50 color:[UIColor swiftColor] since:@"Since 2014" frame:CGRectMake(20, originY, width, 65)];
            [s runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s];
            
            // HTML bar
            SkillView *s5 = [[SkillView alloc] initWithName:@"HTML" percentage:45 color:[UIColor htmlColor] since:@"Since 2010" frame:CGRectMake(20, originY - 50, width, 65)];
            [s5 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s5];
            
            // CSS bar
            SkillView *s6 = [[SkillView alloc] initWithName:@"CSS" percentage:40 color:[UIColor cssColor] since:@"Since 2010" frame:CGRectMake(20, originY - 100, width, 65)];
            [s6 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s6];
            
            // Ruby bar
            SkillView *s7 = [[SkillView alloc] initWithName:@"Ruby" percentage:25 color:[UIColor rubyColor] since:@"Since 2015" frame:CGRectMake(20, originY - 150, width, 65)];
            [s7 runAnimationWithDuration:2 delay:0.5];
            [card addSubview:s7];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCard
{
    [card removeFromSuperview];
}

- (void)setupAnimation
{
    // First animation to setup the views
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        helloLabel.alpha = 1;
        
        [UIView animateWithDuration:0.8 delay:0.3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            subtitleLabel.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
