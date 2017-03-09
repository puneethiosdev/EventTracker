//
//  DetailViewController.h
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 Puneet Kumar. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"

@interface DetailViewController : RootViewController
@property (nonatomic,strong) Event *event;
@end
