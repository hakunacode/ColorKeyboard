//
//  KeyView.m
//  ColorKeyboard
//
//  Created by admin on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyView.h"
#import "GameUtils.h"

@implementation KeyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id) initWithKey:(int)key keyboardkind:(int)kind position:(CGPoint)position {
    m_nKey = key;
    m_nKeyboardKind = kind;
    CGSize size = [g_GameUtils getKeySize:key];
    CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
    [self initWithFrame:frame];
    
    m_imgReleased = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (key == KEY_ABC) {
        NSLog(@"%@",@"abc key");
    }
    NSString* strPath = [g_GameUtils getReleasedKeyImagePath:kind key:key];
    NSString* strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getNormalKeyImageName:key] ofType:@"png" inDirectory:strPath];
    UIImage* imgN = [[UIImage alloc] initWithContentsOfFile:strImg];
    if (imgN == nil || strImg == nil) {
        NSLog(@"%@", @"key normal image is nil");
    }
    [m_imgReleased setImage:imgN];
    [self addSubview:m_imgReleased];
    [imgN release];
    
    strPath = [g_GameUtils getPressedKeyImagePath:kind key:key];
    strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getPressedKeyImageName:key] ofType:@"png" inDirectory:strPath];
    UIImage* imgP = [[UIImage alloc] initWithContentsOfFile:strImg];
    if (imgP == nil) {
        NSLog(@"key pressed image is nil(%@)", [g_GameUtils getPressedKeyImageName:key]);
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize sizeP = CGSizeMake(imgP.size.width/2, imgP.size.height/2);
        CGFloat offsetY = 0;
        if ([g_GameUtils isiPhonePressedBigKey:key])
            offsetY = 2;
        m_imgPressed = [[UIImageView alloc] initWithFrame:CGRectMake((size.width-sizeP.width)/2, size.height-sizeP.height+offsetY, sizeP.width, sizeP.height)];
    }
    else {
        m_imgPressed = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    [m_imgPressed setImage:imgP];
    [self addSubview:m_imgPressed];
    [imgP release];
    
    m_imgPressed.hidden = YES;
    
    m_nKeyState = KS_RELEASED;
    
    return self;
}
- (void) changePosition:(CGPoint)position {
    CGSize size = [g_GameUtils getKeySize:m_nKey];
    CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
    self.frame = frame;
    m_imgReleased.frame = CGRectMake(0, 0, size.width, size.height);
    m_imgPressed.frame = CGRectMake(0, 0, size.width, size.height);
    [self setKeyImage:m_nKeyboardKind];
}
- (void) setKeyImage:(int)kind {
    m_nKeyboardKind = kind;
    NSString* strPath = [g_GameUtils getReleasedKeyImagePath:kind key:m_nKey];
    NSString* strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getNormalKeyImageName:m_nKey] ofType:@"png" inDirectory:strPath];
    UIImage* imgN = [[UIImage alloc] initWithContentsOfFile:strImg];
    [m_imgReleased setImage:imgN];
    [imgN release];
    
    strPath = [g_GameUtils getPressedKeyImagePath:kind key:m_nKey];
    strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getPressedKeyImageName:m_nKey] ofType:@"png" inDirectory:strPath];
    UIImage* imgP = [[UIImage alloc] initWithContentsOfFile:strImg];
    
    [m_imgPressed setImage:imgP];
    [imgP release];
}
- (void) dealloc {
    [m_imgReleased release];
    [m_imgPressed release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    m_imgPressed.hidden = NO;
//}
//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    m_imgPressed.hidden = YES;
//}
//- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    m_imgPressed.hidden = YES;
//}
- (void) SetChangeStatus:(int)nStatus {
    if (nStatus == m_nKeyState)
        return;
    m_nKeyState = nStatus;
    m_imgPressed.hidden = (m_nKeyState == KS_PRESSED) ? NO : YES;
}
- (int) GetKeyStatus {
    return m_nKeyState;
}

@end
