//
//  UIButton+SnapAdditions.m
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import "UIButton+SnapAdditions.h"
#import "UIFont+SnapAdditions.h"

@implementation UIButton (SnapAdditions)

-(void)rw_applySnapStyle
{
    self.titleLabel.font = [UIFont rw_snapFontWithSize:20.0f];
    UIImage *buttonImage = [[UIImage imageNamed:@"Button"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    UIImage *pressedImage = [[UIImage imageNamed:@"ButtonPressed"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
}

@end
