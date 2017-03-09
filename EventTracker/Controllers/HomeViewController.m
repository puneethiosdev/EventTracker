//
//  HomeViewController.m
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 PuneetKumar. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Event.h"
#import "EventCell.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray<Event *> *eventArray;
@property (nonatomic) BOOL isGridView;

@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, strong) NSIndexPath *snapshotIndexPath;
@property (nonatomic) CGPoint snapshotPanPoint;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventArray = [[NSMutableArray alloc] initWithArray:[self getEventDataForUser:self.userName]];
    if (!self.eventArray.count) {
        [self saveEventDataForUserName:self.userName];
    }
    [self addChangeViewButtonToNavigationBar];
    [self addPanGestureToCollectionView];
}

-(void)addPanGestureToCollectionView{
    UILongPressGestureRecognizer *gestureReconizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    gestureReconizer.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:gestureReconizer];
}

-(void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath == nil) {
                return;
            }
            EventCell *cell = (EventCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            self.snapshotView = [cell snapshotViewAfterScreenUpdates:true];
            
            CGRect frame = self.snapshotView.frame;
            frame.origin.x = cell.frame.origin.x;
            frame.origin.y = cell.frame.origin.y;
            self.snapshotView.frame = frame;
            
            [self.collectionView addSubview:self.snapshotView];
            cell.contentView.alpha = 0.0;
            [UIView animateWithDuration:0.2 animations:^{
                self.snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                self.snapshotView.alpha = 0.9;
            }];
            self.snapshotPanPoint = location;
            self.snapshotIndexPath = indexPath;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translatingPoint = CGPointMake(location.x - self.snapshotPanPoint.x, location.y - self.snapshotPanPoint.y);
            self.snapshotView.center = CGPointMake(self.snapshotView.center.x + translatingPoint.x, self.snapshotView.center.y + translatingPoint.y);
            self.snapshotPanPoint = location;
            
            if (indexPath == nil) {
                return;
            }
            
            Event *event = [self.eventArray objectAtIndex:self.snapshotIndexPath.row];
            [self.eventArray removeObjectAtIndex:self.snapshotIndexPath.row];
            [self.eventArray insertObject:event atIndex:indexPath.row];
            
            [self.collectionView moveItemAtIndexPath:self.snapshotIndexPath toIndexPath:indexPath];
            
            NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
            for (NSIndexPath *indexPath in visibleIndexPaths) {
                [self updateEventForIndex:(int)indexPath.row];
            }
            
            self.snapshotIndexPath = indexPath;
        }
            break;
            
        default:{
            if (self.snapshotIndexPath == nil) {
                return;
            }
            EventCell *cell = (EventCell *)[self.collectionView cellForItemAtIndexPath:self.snapshotIndexPath];
            [UIView animateWithDuration:0.2 animations:^{
                self.snapshotView.center = cell.center;
                self.snapshotView.transform = CGAffineTransformIdentity;
                self.snapshotView.alpha = 1.0;
            } completion:^(BOOL finished) {
                cell.contentView.alpha = 1.0;
                [self.snapshotView removeFromSuperview];
                self.snapshotView = nil;
            }];
        }
            self.snapshotIndexPath = nil;
            break;
    }
}

-(void)addChangeViewButtonToNavigationBar{
    UIBarButtonItem *button;
    if (self.isGridView) {
        button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"listview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeViewButtonPressed:)];
    }else{
        button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gridview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeViewButtonPressed:)];
    }
    
    self.navigationItem.rightBarButtonItem = button;
}

-(void)changeViewButtonPressed:(UIBarButtonItem *)sender{
    if (self.isGridView) {
        self.isGridView = false;
    }else{
        self.isGridView = true;
    }
    [self.collectionView reloadData];
    [self addChangeViewButtonToNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isGridView) {
        int width = (collectionView.bounds.size.width - 28)/3;
        return CGSizeMake(width, width + 57);
    }else{
        int width = collectionView.bounds.size.width;
        return CGSizeMake(width - 20, 120);
    }
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
    EventCell *cell;
    if (self.isGridView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventGridCell" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventListCell" forIndexPath:indexPath];
    }
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

-(void)trackEventButtonPressed:(UIButton *)sender{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    EventCell *cell = (EventCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    Event *event = [self.eventArray objectAtIndex:indexPath.row];
    if ([event.isTracking intValue]) {
        event.isTracking = @"0";
        [cell.trackingButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }else{
        event.isTracking = @"1";
        [cell.trackingButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DetailViewController *destinationViewController = (DetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DetailVC"];
    destinationViewController.event = [self.eventArray objectAtIndex:indexPath.row];
    destinationViewController.userName = self.userName;
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

-(NSArray *)getEventDataForUser:(NSString *)userName{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [request setPredicate:predicateName];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];\
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

-(void)saveEventDataForUserName:(NSString *)userName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Event" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *eventArrayFromJSON = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int index = 0;
    for (NSDictionary *eventData in eventArrayFromJSON) {
        Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                       inManagedObjectContext:appDelegate.managedObjectContext];
        event.name = [eventData valueForKey:@"eventName"];
        event.location = [eventData valueForKey:@"location"];
        event.entryType = [eventData valueForKey:@"entryType"];
        event.rating = [eventData valueForKey:@"rating"];
        event.descriptionText = [eventData valueForKey:@"description"];
        event.imageName = [eventData valueForKey:@"image_name"];
        event.isTracking = @"0";
        event.userName = userName;
        event.index = [NSNumber numberWithInt:index];
        
        [self.eventArray addObject:event];
        index++;
    }
    
    [appDelegate saveContext];
}

-(void)updateEventForIndex:(int)index{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Event *event = [self.eventArray objectAtIndex:index];
    event.index = [NSNumber numberWithInt:index];
    [appDelegate saveContext];
}

-(void)updateViewsForNotification:(NSNotification *)notification{
    Event *event = (Event *)notification.userInfo;
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[event.index intValue] inSection:0]]];
}


@end
