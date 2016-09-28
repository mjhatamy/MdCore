//
//  AppDelegate.h
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

