//
//  TrackingViewController.h
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol TrackingVCDelegate <NSObject>
@optional
-(void)showDetailsForEvent:(Event *)event;
@end

@interface TrackingViewController : UIViewController
@property (nonatomic,strong) NSString *userName;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (assign, nonatomic) id<TrackingVCDelegate> delegate;
@end
