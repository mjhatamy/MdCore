//
//  ViewController.h
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BooksListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *bookListCollectionView;

@end

