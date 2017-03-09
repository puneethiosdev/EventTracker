//
//  AppDelegate.h
//  EventTracker
//
//  Created by Puneet Kumar on 08/10/16.
//  Copyright © 2016 Puneet Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define APP_THEME_COLOR [UIColor colorWithRed:125.0/255.0 green:4.0/255.0 blue:0/255.0 alpha:1.0]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

