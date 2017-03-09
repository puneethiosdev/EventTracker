//
//  TrackingViewController.m
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import "TrackingViewController.h"
#import "AppDelegate.h"
#import "EventCell.h"

@interface TrackingViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray<Event *> *eventArray;
@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"concrete_seamless"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.eventArray = [[NSMutableArray alloc] initWithArray:[self getTrackingEventDataForUser:self.userName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)getTrackingEventDataForUser:(NSString *)userName{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"userName contains[cd] %@ AND isTracking contains[cd] 1", userName];
    
    [request setPredicate:predicateName];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];\
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = collectionView.bounds.size.width;
    return CGSizeMake(width - 20, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.eventArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventListCell" forIndexPath:indexPath];
    Event *event = [self.eventArray objectAtIndex:indexPath.row];
    cell.eventImageView.image = [UIImage imageNamed:event.imageName];
    cell.eventNameLabel.text = event.name;
    cell.ratingLabel.text = [NSString stringWithFormat:@"%.01f",[event.rating floatValue]];
    cell.eventEntryTypeLabel.text = event.entryType;
    cell.locationLabel.text = event.location;
    
    cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star_unfilled"];
    cell.ratingImageView2.image = [UIImage imageNamed:@"icon_star_unfilled"];
    cell.ratingImageView3.image = [UIImage imageNamed:@"icon_star_unfilled"];
    cell.ratingImageView4.image = [UIImage imageNamed:@"icon_star_unfilled"];
    cell.ratingImageView5.image = [UIImage imageNamed:@"icon_star_unfilled"];
    
    if ([event.rating intValue] == 1) {
        
        cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([event.rating intValue] == 2) {
        
        cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView2.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([event.rating intValue] == 3) {
        
        cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView2.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView3.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([event.rating intValue] == 4) {
        
        cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView2.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView3.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView4.image = [UIImage imageNamed:@"icon_star"];
        
    }else if ([event.rating intValue] == 5) {
        
        cell.ratingImageView1.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView2.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView3.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView4.image = [UIImage imageNamed:@"icon_star"];
        cell.ratingImageView5.image = [UIImage imageNamed:@"icon_star"];
        
    }
    
    if ([event.isTracking intValue]) {
        [cell.trackingButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    }else{
        [cell.trackingButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }
    
    [cell.trackingButton addTarget:self action:@selector(trackEventButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    cell.layer.cornerRadius = 5.0;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.2;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate showDetailsForEvent:[self.eventArray objectAtIndex:indexPath.row]];
}

-(void)trackEventButtonPressed:(UIButton *)sender{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    Event *event = [self.eventArray objectAtIndex:indexPath.row];
    event.isTracking = @"0";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.eventArray removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_TRACKING_DETAILS" object:nil userInfo:event];
}

@end
