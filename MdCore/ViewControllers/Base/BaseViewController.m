//
//  BaseViewController.m
//  MdCore
//
//  Created by Majid Hatami Aghdam on 9/26/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTitle:(NSString *)title navBarHidden:(BOOL)navBarHidden {
    m_navBarHidden = navBarHidden;
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = title;
    }
    
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    m_visible = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    m_visible = YES;
    UINavigationController *navController = self.navigationController;
    
    if (navController != nil) {
        [navController setNavigationBarHidden:m_navBarHidden animated:NO];
    }
}

- (void)cleanUp {
}

@end
