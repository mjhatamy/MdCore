//
//  BookItemUICollectionViewCell.m
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import "BookItemUICollectionViewCell.h"

@implementation BookItemUICollectionViewCell

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setHighlighted:selected];
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(self.highlighted){
        self.layer.borderColor = [UIColor colorWithRed:73.0f/255.0f green:157.0f/255.0f blue:227.0f/255.0f alpha:1.0f].CGColor;
        self.layer.borderWidth = 4.0f;
    }else{
        //self.layer.borderColor = [UIColor clearColor].CGColor;
        //self.layer.borderWidth = 0.0f;
    }
}

@end
