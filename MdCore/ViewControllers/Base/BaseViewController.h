//
//  BaseViewController.h
//  MdCore
//
//  Created by Majid Hatami Aghdam on 9/26/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDContainer.h"

@interface BaseViewController : UIViewController <RDContainerDelegate> {
    @private BOOL m_navBarHidden;
    @private BOOL m_visible;
}

- (void)cleanUp;
- (id)initWithTitle:(NSString *)title navBarHidden:(BOOL)navBarHidden;

@end
