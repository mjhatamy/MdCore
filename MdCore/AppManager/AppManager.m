//
//  AppManager.m
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import "AppManager.h"
#import "EPubViewController.h"

@implementation AppManager

+(id) SharedInstance{
    static AppManager* sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(NSArray *)getBookLists{
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.epub'"];
    NSArray *onlyPDFs = [dirContents filteredArrayUsingPredicate:fltr];
    
    NSMutableArray* listOfPath = [[NSMutableArray alloc] initWithCapacity:onlyPDFs.count];
    for (NSString* path in onlyPDFs) {
        [listOfPath addObject:[[NSBundle mainBundle] pathForResource:path.stringByDeletingPathExtension ofType:@".epub"]];
    }
    
    return listOfPath;
}

-(NSString *)getBookTitleByBookPath:(NSString *)path  ViewController:(BaseViewController *)ViewController{
    RDContainer *m_container = [[RDContainer alloc] initWithDelegate:ViewController path:path];
    RDPackage *m_package = m_container.firstPackage;
    
    //[self popErrorMessage];
    if(m_package == nil) return nil;
    return m_package.title;
}

-(UIImage *)getBookFirstPageSnapshotByBookPath:(NSString *)path ViewController:(BaseViewController *)ViewController{
    RDContainer *m_container = [[RDContainer alloc] initWithDelegate:ViewController path:path];
    RDPackage *m_package = m_container.firstPackage;
    
    //[self popErrorMessage];
    if(m_package == nil) return nil;
    RDSpineItem *spineItem = [m_package.spineItems objectAtIndex:0];
    if(spineItem == nil) return nil;
    
    EPubViewController *c = [[EPubViewController alloc] initWithContainer:m_container package:m_package spineItem:spineItem cfi:nil];
    
    return [c pb_takeSnapshot];
}

@end
