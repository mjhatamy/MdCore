//
//  AppManager.h
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseViewController.h"
#import "RDContainer.h"
#import "RDPackage.h"
#import "RDSpineItem.h"

@interface AppManager : NSObject

+(id) SharedInstance;


-(NSArray *)getBookLists;


//EPUB 
-(NSString *)getBookTitleByBookPath:(NSString *)path  ViewController:(BaseViewController *)ViewController;
-(UIImage *)getBookFirstPageSnapshotByBookPath:(NSString *)path ViewController:(BaseViewController *)ViewController;

@end
