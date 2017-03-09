//
//  DetailViewController.m
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 Puneet Kumar. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryType;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage5;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackingButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventImageView.image = [UIImage imageNamed:self.event.imageName];
    self.eventName.text = self.event.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.01f",[self.event.rating floatValue]];
    self.eventEntryType.text = self.event.entryType;
    self.eventLocation.text = self.event.location;
    self.descriptionLabel.text = self.event.descriptionText;
    
    if ([self.event.rating intValue] == 1) {
        
        self.ratingImage1.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([self.event.rating intValue] == 2) {
        
        self.ratingImage1.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage2.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([self.event.rating intValue] == 3) {
        
        self.ratingImage1.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage2.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage3.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([self.event.rating intValue] == 4) {
        
        self.ratingImage1.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage2.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage3.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage4.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([self.event.rating intValue] == 5) {
        
        self.ratingImage1.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage2.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage3.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage4.image = [UIImage imageNamed:@"icon_star"];
        self.ratingImage5.image = [UIImage imageNamed:@"icon_star"];
    }
    
    if ([self.event.isTracking intValue]) {
        [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    }else{
        [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.event.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)trackingButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self.event.isTracking intValue]) {
        self.event.isTracking = @"0";
        [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }else{
        self.event.isTracking = @"1";
        [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    }
    [appDelegate saveContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_TRACKING_DETAILS" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_TRACKING_DETAILS" object:nil userInfo:self.event];
}

-(void)updateViewsForNotification:(NSNotification *)notification{
    Event *event = (Event *)notification.userInfo;
    if (event.index == self.event.index) {
        if ([event.isTracking intValue]) {
            [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
        }else{
            [self.trackingButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];

        }
    }
}

@end
