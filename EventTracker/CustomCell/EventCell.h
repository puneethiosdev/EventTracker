//
//  EventCell.h
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView5;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackingButton;
@end
