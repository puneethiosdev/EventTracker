//
//  RootViewController.m
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import "RootViewController.h"
#import "TrackingViewController.h"
#import "UserNameViewController.h"
#import "DetailViewController.h"

@interface RootViewController ()<TrackingVCDelegate>
@property (nonatomic,strong) TrackingViewController *trackingVC;
@property (nonatomic) CGPoint panningOrigin;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"concrete_seamless"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if (![self isKindOfClass:[UserNameViewController class]]) {
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self.view addGestureRecognizer:gestureRecognizer];
    }
    
}

-(void)panGestureRecognized:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panningOrigin = location;
            if (self.trackingVC == nil) {
                if (location.x > [UIScreen mainScreen].bounds.size.width - 50) {
                    [self addTrackingView];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            if (self.trackingVC != nil) {
                CGPoint velocity = [gestureRecognizer velocityInView:self.view];
                
                if (velocity.x < 0) {
                    if (self.trackingVC.view.frame.origin.x > 0) {
                        self.trackingVC.view.center = CGPointMake(location.x, self.trackingVC.view.center.y);
                    }else{
                        self.trackingVC.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.trackingVC.view.center.y);
                    }
                }else{
                    self.trackingVC.view.center = CGPointMake(self.trackingVC.view.center.x + location.x - self.panningOrigin.x, self.trackingVC.view.center.y);
                }
                self.panningOrigin = location;
                self.trackingVC.backGroundView.alpha = ([UIScreen mainScreen].bounds.size.width/2 - self.trackingVC.view.frame.origin.x)/[UIScreen mainScreen].bounds.size.width;
            }
        }
            break;
            
        default:
            if (self.trackingVC != nil) {
                if (self.trackingVC.view.frame.origin.x <= [UIScreen mainScreen].bounds.size.width/4) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect frame = self.trackingVC.view.frame;
                        frame.origin.x = 0;
                        self.trackingVC.view.frame = frame;
                    } completion:^(BOOL finished) {
                        
                    }];
                }else{
                    [self removeTrackingViewWithAnimationTime:0.2];
                }
            }
            break;
    }
}


-(void)addTrackingView{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TrackingViewController *trackingVC = (TrackingViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"TrackingVC"];
    trackingVC.userName = self.userName;
    trackingVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:trackingVC.view];
    trackingVC.delegate = self;
    
    [self addChildViewController:trackingVC];
    [trackingVC didMoveToParentViewController:self];
    trackingVC.backGroundView.alpha = 0.0;
    
    self.trackingVC = trackingVC;
}

-(void)removeTrackingViewWithAnimationTime:(NSTimeInterval)time{
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.trackingVC.view.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width/2;
        self.trackingVC.view.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.trackingVC.view removeFromSuperview];
        [self.trackingVC removeFromParentViewController];
        self.trackingVC = nil;
    }];
}

-(void)showDetailsForEvent:(Event *)event{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DetailViewController *destinationViewController = (DetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DetailVC"];
    destinationViewController.event = event;
    destinationViewController.userName = self.userName;
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           [UIFont fontWithName:@"Avenir-Medium" size:20.0], NSFontAttributeName, nil];
    
    
    self.navigationController.navigationBar.titleTextAttributes = attrs;
    self.navigationController.navigationBar.topItem.title = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewsForNotification:) name:@"UPDATE_TRACKING_DETAILS"  object:nil];
}

-(void)updateViewsForNotification:(NSNotification *)notification{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTrackingViewWithAnimationTime:0.01];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_TRACKING_DETAILS" object:nil];
}

@end
