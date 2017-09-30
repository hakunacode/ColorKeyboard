//
//  StyleTextView.m
//  ColorText
//
//  Created by  on 12/03/24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StyleTextView.h"

@implementation StyleTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    NSString* temp = self.text;
//    [temp drawAtPoint:CGPointMake(8, 8) withFont:[UIFont systemFontOfSize:14]];
    
}

//- (void) drawTextInRect:(CGRect)rect {
//    CGSize myShadowOffset = CGSizeMake(4, -4);
//    float myColorValues[] = {0, 0, 0, .8};
//    
//    CGContextRef myContext = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(myContext);
//    
//    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
//    CGContextSetShadowWithColor (myContext, myShadowOffset, 5, myColor);
//    
//    [super drawTextInRect:rect];
//    
//    CGColorRelease(myColor);
//    CGColorSpaceRelease(myColorSpace); 
//    
//    CGContextRestoreGState(myContext);
//}
@end
