//
//  MainView.m
//  Keyboard
//
//  Created by YCH on 2011.11.02

#import "KeyboardView.h"
#import "MainViewController.h"
#import "GameUtils.h"
#import "KeyView.h"

@implementation KeyboardView

@synthesize m_sCurString;
@synthesize m_bKeyboardAppear;

#define kTagKey     0x30

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    //check del key
//    if (m_nSelKey == 27)
//    {
//        if ([g_GameUtils GetTickCount] - m_uStartDel > 2000 && !m_bIsDel)
//        {
//            [self setTimeDel];
//        }
//    }
}
*/

//#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)

- (id)initView:(MainViewController* )parent
{
//    // SKY:121023:start
//    _PHONE_LAND_WIDTH = PHONE_LAND_WIDTH;
//    if ( IS_IPHONE_5 )
//        _PHONE_LAND_WIDTH = 568;
//    // SKY:end
    
    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([g_GameUtils isPortraitMode])
            frame = CGRectMake(0, PHONE_LAND_WIDTH - NAV_PORT_H, PHONE_PORT_WIDTH, PHONE_PORT_HEIGHT);
        else
            frame = CGRectMake(0, 320 - NAV_LAND_H, PHONE_LAND_WIDTH, PHONE_LAND_HEIGHT);
    }
    else
    {
        if ([g_GameUtils isPortraitMode])
            frame = CGRectMake(0, 1024 - NAV_PORT_H, PAD_PORT_WIDTH, PAD_PORT_HEIGHT);
        else
            frame = CGRectMake(0, 768 - NAV_PORT_H, PAD_LAND_WIDTH, PAD_LAND_HEIGHT);
    }
    [self initWithFrame:frame];

    m_parent = parent;
    m_nKeyboardKind = KK_BLUE;
    m_nKeyboardType = KEYBOARD_NORMAL;
    
    m_imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:m_imgBg];
    [self setBgImage:m_nKeyboardKind];
    
    m_arrayPoint = [[NSMutableArray alloc] init];
    
    [self CreateKeyViews];
    
    //init key data
    m_nSelKey = -1;
    m_bCaps = NO;
    self.m_sCurString = @"";
    m_strText = [[NSMutableString alloc] init];
    
    m_bIsButton = NO;
    m_bKeyboardAppear = NO;
    
    return self;
}

-(void) CreateKeyViews
{
    for (int i = KEY_Q; i < KEY_COUNT; i ++) {
        CGPoint pos = [g_GameUtils getKeyPosition:i];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            CGSize size = [g_GameUtils getKeySize:i];
//            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, size.width, size.height)];
//            NSString* strPath = [g_GameUtils getReleasedKeyImagePath:m_nKeyboardKind key:i];
//            NSString* strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getiPhonePortraitNormalKeyImageName:i] ofType:@"png" inDirectory:strPath];
//            UIImage* imgN = [[UIImage alloc] initWithContentsOfFile:strImg];
//            strPath = [g_GameUtils getPressedKeyImagePath:m_nKeyboardKind key:i];
//            strImg = [[NSBundle mainBundle] pathForResource:[g_GameUtils getiPhonePortraitPressedKeyImageName:i] ofType:@"png" inDirectory:strPath];
//            UIImage* imgP = [[UIImage alloc] initWithContentsOfFile:strImg];
//            [btn setImage:imgN forState:UIControlStateNormal];
//            [btn setImage:imgP forState:UIControlStateHighlighted];
//            [btn addTarget:self action:@selector(onClickKey:) forControlEvents:UIControlEventTouchUpInside];
//            btn.tag = kTagKey+i;
//            [self addSubview:btn];
//            [imgN release];
//            [imgP release];
//            [btn release];
            if ([g_GameUtils isOnlyiPhoneKey:i])
                continue;
            KeyView* keyV = [[KeyView alloc] initWithKey:i keyboardkind:m_nKeyboardKind position:pos];
            keyV.tag = kTagKey+i;
            [self addSubview:keyV];
            [keyV release];
        }
        else {
            if ([g_GameUtils isOnlyiPadKey:i] == YES)
                continue;
            KeyView* keyV = [[KeyView alloc] initWithKey:i keyboardkind:m_nKeyboardKind position:pos];
            keyV.tag = kTagKey+i;
            [self addSubview:keyV];
            [keyV release];
        }
    }
    [self updateKeyViews];
}
- (void) updateKeyViews {
    for (int i = KEY_Q; i < KEY_COUNT; i ++) {
        UIView* viewKey = [self viewWithTag:i+kTagKey];
        BOOL bShow = [g_GameUtils isEnableKeyWithType:m_nKeyboardType key:i];
        viewKey.hidden = !bShow;
        if (i >= KEY_DOT && i<= KEY_UPPERCOMMA) {
            [self bringSubviewToFront:viewKey];
        }
    }
}
- (void) changeKeyboardKind:(int)kind {
    if (kind == m_nKeyboardKind)
        return;
    m_nKeyboardKind = kind;
    [self setBgImage:kind];
    for (int i = KEY_Q; i < KEY_COUNT; i ++) {
        KeyView* viewKey = (KeyView*)[self viewWithTag:i+kTagKey];
        [viewKey setKeyImage:m_nKeyboardKind];
    }
}
-(void) setBgImage:(int)kind {
    NSString* strImg = [[NSBundle mainBundle] pathForResource:@"BACKGROUND" ofType:@"png" inDirectory:[g_GameUtils getKeyboardRootPath:kind]];
    UIImage* img = [UIImage imageWithContentsOfFile:strImg];
    [m_imgBg setImage:img];
}

- (void) onClickKey:(id)sender {
    
}

- (bool) isShiftKey:(int)nKey {
    if (nKey == KEY_CAP || nKey == KEY_CAP_IPAD)//caps key
        return true;
    return false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //init infomation
    self.m_sCurString = @"";
    [m_strText setString:@""];
    
    //touch part
    UITouch *touch = [touches anyObject];
    if ([touches count] != 1 || [touch tapCount] != 1) {
        return;
    }
    CGPoint location = [touch locationInView:self];
    int nKey;
    nKey = [self GetKeyID:location];
//    NSLog(@"t begin x=%f, y=%f ",location.x, location.y);
    
    if (nKey == -1)
        return;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || YES)
    {
        KeyView* keyV = (KeyView*)[self viewWithTag:nKey+kTagKey];
        if ([self isShiftKey:nKey])//caps key
        {
            //[self onKeyProc:nKey];
            m_bCaps = true;
            m_bShiftPressed = true;

            KeyView* keyV1 = (KeyView*)[self viewWithTag:KEY_CAP+kTagKey];
            if ( keyV1 != nil )
                [keyV1 SetChangeStatus:KS_PRESSED];
            KeyView* keyV2 = (KeyView*)[self viewWithTag:KEY_CAP_IPAD+kTagKey];
            if ( keyV2 != nil )
                [keyV2 SetChangeStatus:KS_PRESSED];
            
        }
        else if (nKey == KEY_BACKSPACE)//back key
        {
            [self onKeyProc:nKey];
            [keyV SetChangeStatus:KS_PRESSED];
            
        }
        else if (nKey == KEY_123 || nKey == KEY_SPS || nKey == KEY_SPEC123 || nKey == KEY_GLOBE || nKey == KEY_ABC || nKey == KEY_123_IPAD || nKey == KEY_SPS_IPAD || nKey == KEY_SPEC123_IPAD || nKey == KEY_ABC_IPAD || nKey == KEY_CLOSE_IPAD)//back key
        {
            [self onKeyProc:nKey];
            [keyV SetChangeStatus:KS_PRESSED];
        }
        else if (nKey == KEY_SPS)//back key
        {
            [self onKeyProc:nKey];
        }
//        else if (nKey == KEY_RETURN)//return key
//        {
//            [keyV SetChangeStatus:PRESSED];
//            
//            //add string
//            NSString* str = @"\n";
//            [self MakeString:str];
//            
//            [m_dictionary setItem:@"\n" uStartTime:[g_GameUtils GetTickCount]];
//        }
        else
        {
            [keyV SetChangeStatus:KS_PRESSED];
            
            //add string
//            NSString* str = [pKeyImage GetKeyString];
//            if (m_bCaps)
//                str = [str uppercaseString];
//            [self MakeString:str];
//            
//            [m_dictionary setItem:str uStartTime:[g_GameUtils GetTickCount]];
        }
        m_nSelKey = nKey;
    }
    else
    {
        if (nKey != -1)
        {
            if (nKey == 21 || nKey == 31)//caps key
            {
                m_bCaps = !m_bCaps;
//                pKeyImage = [m_aryKey objectAtIndex:nKey]; 
//                if (m_bCaps)
//                    [pKeyImage SetChangeStatus:PRESSED];
//                else
//                    [pKeyImage SetChangeStatus:RELEASED];
            }
            else if (nKey == 10)//back key
            {
//                m_nSelKey = nKey;
//                pKeyImage = [m_aryKey objectAtIndex:nKey];
//                [pKeyImage SetChangeStatus:PRESSED];
//                [self delString];
            }
            else if (nKey == 20)//return key
            {
//                m_nSelKey = nKey;
//                pKeyImage = [m_aryKey objectAtIndex:nKey];
//                [pKeyImage SetChangeStatus:PRESSED];
//                
//                //add string
//                NSString* str = @"\n";
//                [self MakeString:str];
//                
//                [m_dictionary setItem:@"\n" uStartTime:[g_GameUtils GetTickCount]];
//                
            }
            else if (nKey == 32 || nKey == 33 ||nKey == 35 || nKey == 36)//none
            {
//                m_nSelKey = nKey;
//                pKeyImage = [m_aryKey objectAtIndex:nKey];
//                [pKeyImage SetChangeStatus:PRESSED];
                
                if (nKey == 36)
                    [m_parent onDone];
                else
                    [m_parent setSwipeSwitch:NO];
                
            }
            else
            {
                m_nSelKey = nKey;
//                pKeyImage = [m_aryKey objectAtIndex:nKey];
//                [pKeyImage SetChangeStatus:PRESSED];
                
                //add string
//                NSString* str = [pKeyImage GetKeyString];
//                if (m_bCaps)
//                {
//                    if (nKey == 29)
//                        str = @",";
//                    else if (nKey == 30)
//                        str = @".";
//                    else
//                        str = [str uppercaseString];
//                }
//                [self MakeString:str];
//                
//                [m_dictionary setItem:str uStartTime:[g_GameUtils GetTickCount]];
            }
            
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
	CGPoint location = [touch locationInView:self];
    CGPoint prevlocation = [touch previousLocationInView:self];
    int nKey, nPrvKey;
    nKey = [self GetKeyID:location];
    nPrvKey = [self GetKeyID:prevlocation];
    
    KeyView* keyV = (KeyView*)[self viewWithTag:m_nSelKey+kTagKey];
    if (m_nSelKey != nKey) {
        if (m_nSelKey != KEY_CAP)
            [keyV SetChangeStatus:KS_RELEASED];
    }
    if (nKey != -1)
    {
        keyV = (KeyView*)[self viewWithTag:nKey+kTagKey];//kgh
        [keyV SetChangeStatus:KS_PRESSED];
        if (nKey != nPrvKey)
        {
//            NSString* str = [key GetKeyString];
//            [self MakeString:str];
        }
    }
    m_nSelKey = nKey;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];

    int nKey;
    nKey = [self GetKeyID:location];
    
   
    if ([self isShiftKey:nKey])//caps key
    {
        m_bShiftPressed = false;

        if (!m_bCaps)
        {
            KeyView* keyV1 = (KeyView*)[self viewWithTag:KEY_CAP+kTagKey];
            if ( keyV1 != nil )
                [keyV1 SetChangeStatus:KS_RELEASED];
            KeyView* keyV2 = (KeyView*)[self viewWithTag:KEY_CAP_IPAD+kTagKey];
            if ( keyV2 != nil )
                [keyV2 SetChangeStatus:KS_RELEASED];
        }
    }
    else
    {
        if (nKey != -1)
        {
            KeyView* keyV = (KeyView*)[self viewWithTag:nKey+kTagKey];
            [keyV SetChangeStatus:KS_RELEASED];
        }
        if (m_nSelKey != -1 && m_nSelKey != nKey) {
            KeyView* keyV = (KeyView*)[self viewWithTag:m_nSelKey+kTagKey];
            [keyV SetChangeStatus:KS_RELEASED];
        }

        if (nKey == KEY_BACKSPACE)//back key
            [self delString];
        else
        {
            BOOL    b = (m_bShiftPressed || m_bCaps);
            [self InsertText:[g_GameUtils getKeyString:nKey bCaps:b]];

            if ( ! m_bShiftPressed && m_bCaps )
            {
                KeyView* keyV1 = (KeyView*)[self viewWithTag:KEY_CAP+kTagKey];
                if ( keyV1 != nil )
                    [keyV1 SetChangeStatus:KS_RELEASED];
                KeyView* keyV2 = (KeyView*)[self viewWithTag:KEY_CAP_IPAD+kTagKey];
                if ( keyV2 != nil )
                    [keyV2 SetChangeStatus:KS_RELEASED];
            }
            if ( m_bCaps )
                m_bCaps = false;
        }
    }

    m_nSelKey = -1;

    //search word from dictionary
    if (m_parent.m_bFindDic)
    {
        if ([self.m_sCurString length] > 3) 
            self.m_sCurString = @"";
        [self InsertText:self.m_sCurString];
    }
    else
    {
        [self InsertText:self.m_sCurString];

    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)MakeString:(NSString*)str
{
    NSString* sNew = [NSString stringWithFormat:@"%@%@", self.m_sCurString, str];
    self.m_sCurString = sNew;
    [m_strText appendString:str];
}


-(int)GetKeyID:(CGPoint)point
{
    CGRect rect;
    for (int i = 0; i < KEY_COUNT; i ++)
    {
        UIView* view = [self viewWithTag:i + kTagKey];
        if (view.hidden == YES)
            continue;
        rect = view.frame;
        if (CGRectContainsPoint(rect, point))
            return i;
    }
    
    return -1;
}

//control string start ---------------------------------------------------------------------------
-(void) delString
{
    //del one char
    NSRange range = m_parent.m_txtView.selectedRange;
    NSInteger npos;
    if (range.location == 0)
        npos = range.location;
    else
        npos = range.location - 1;
    
    NSString * sFirst = [m_parent.m_txtView.text substringToIndex:npos];   
    NSString * sEnd = [m_parent.m_txtView.text substringFromIndex: (range.location + range.length)];  
    
    NSString* sNew = [NSString stringWithFormat: @"%@%@", sFirst, sEnd];
    [m_parent.m_txtView setText:sNew];
    
    //set current cursor
    NSRange newrange;
    newrange.location =  npos;
    newrange.length= 0;
    m_parent.m_txtView.selectedRange = newrange;
    
}

-(void)InsertText:(NSString*)str
{
    if ([str length] == 0)
        return;
    if ([str length] > 1)
        str = [NSString stringWithFormat: @"%@ ", str];//if str is word str add backspace
    
    //insert text
     NSRange range = m_parent.m_txtView.selectedRange;   
     NSString * sFirst = [m_parent.m_txtView.text substringToIndex:range.location];   
     NSString * sEnd = [m_parent.m_txtView.text substringFromIndex: (range.location + range.length)];  
     
     NSString* sNew = [NSString stringWithFormat: @"%@%@%@", sFirst, str, sEnd];
     [m_parent.m_txtView setText:sNew];
    
    //set current cursor
    NSRange newrange;
    newrange.location =  range.location + [str length];
    newrange.length= 0;
    m_parent.m_txtView.selectedRange = newrange;

}
//control string end ----------------------------------------------------------------------------
-(void)animationView:(BOOL)bUp
{
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    [UIView beginAnimations:@"ani" context:context]; 
	[UIView setAnimationBeginsFromCurrentState: YES];     
    [UIView setAnimationDuration:0.4]; 
    
    CGRect frame = self.frame;
    CGFloat fMove;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([g_GameUtils isPortraitMode])
            fMove = PHONE_PORT_HEIGHT;
        else
            fMove = PHONE_LAND_HEIGHT;
    }
    else
    {
        if ([g_GameUtils isPortraitMode])
            fMove = PAD_PORT_HEIGHT;
        else
            fMove = PAD_LAND_HEIGHT;
        
    }

    if (bUp)
        frame.origin.y -= fMove;//64 - navigation bar height + status height 
    else
        frame.origin.y += fMove; 
    
    self.frame = frame; 
	[UIView commitAnimations]; 
    
    //view appear flag
    if (bUp)
        m_bKeyboardAppear = YES;
    else
        m_bKeyboardAppear = NO;
    
    [self setNeedsDisplay];
    
}

-(void)layoutSubviews
{
    CGRect frame;
    CGFloat x, y, w, h;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (m_bKeyboardAppear)
        {
            if ([g_GameUtils isPortraitMode])
            {
                x = 0;
                y = PHONE_LAND_WIDTH - NAV_PORT_H - PHONE_PORT_HEIGHT;
                w = PHONE_PORT_WIDTH;
                h = PHONE_PORT_HEIGHT;
                
            }
            else
            {
                x = 0;
                y = 320 - NAV_LAND_H - PHONE_LAND_HEIGHT;
                w = PHONE_LAND_WIDTH;
                h = PHONE_LAND_HEIGHT;
                
            }
        }
        else
        {
            if ([g_GameUtils isPortraitMode])
            {
                x = 0;
                y = PHONE_LAND_WIDTH - NAV_PORT_H;
                w = PHONE_PORT_WIDTH;
                h = PHONE_PORT_HEIGHT;
            }
            else
            {
                x = 0;
                y = 320 - NAV_LAND_H;
                w = PHONE_LAND_WIDTH;
                h = PHONE_LAND_HEIGHT;
            }
        }
        
    }
    else
    {
        if (m_bKeyboardAppear)
        {
            if ([g_GameUtils isPortraitMode])
            {
                x = 0;
                y = 1024 - NAV_PORT_H - PAD_PORT_HEIGHT;
                w = PAD_PORT_WIDTH;
                h = PAD_PORT_HEIGHT;
                
            }
            else
            {
                x = 0;
                y = 768 - NAV_PORT_H - PAD_LAND_HEIGHT;
                w = PAD_LAND_WIDTH;
                h = PAD_LAND_HEIGHT;
                
            }
        }
        else
        {
            if ([g_GameUtils isPortraitMode])
            {
                x = 0;
                y = 1024 - NAV_PORT_H;
                w = PAD_PORT_WIDTH;
                h = PAD_PORT_HEIGHT;
            }
            else
            {
                x = 0;
                y = 768 - NAV_PORT_H;
                w = PAD_LAND_WIDTH;
                h = PAD_LAND_HEIGHT;
            }
        }
    }
    
    
    frame = CGRectMake(x, y, w, h);
    self.frame = frame;
    m_imgBg.frame = CGRectMake(0, 0, w, h);
    [self setBgImage:m_nKeyboardKind];
    [self changeOrientation];
}
-(void) changeOrientation {
    for (int i = KEY_Q; i < KEY_COUNT; i ++) {
        CGPoint pos = [g_GameUtils getKeyPosition:i];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if ([g_GameUtils isOnlyiPhoneKey:i])
                continue;
            KeyView* keyV = (KeyView*)[self viewWithTag:kTagKey+i];
            [keyV changePosition:pos];
        }
        else {
        }
    }
}

/*
-(void)setTimeDel
{
    m_bIsDel = YES;
    m_tmDel = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(autoDel) userInfo:nil repeats:YES];
    [m_tmDel retain];
}

-(void)autoDel
{
    int nn = 2;
}

-(void)delTimerDel
{
    m_bIsDel = NO;
    if (m_tmDel)
    {
        [m_tmDel invalidate];
        [m_tmDel release];
        m_tmDel = nil;
    }
}
*/
- (void)dealloc
{
    [m_aryKey removeAllObjects];
    [m_aryKey release];
    
    [m_arrayPoint removeAllObjects];
    [m_arrayPoint release];
    
    [m_strText release];
    [super dealloc];
}

- (void) onKeyProc:(int)key {
    switch (key) {
        case KEY_CAP:
        case KEY_CAP_IPAD:
            //m_bCaps = !m_bCaps;
            break;
        case KEY_BACKSPACE:
            break;
        case KEY_123:
        case KEY_123_IPAD:
            if (m_nKeyboardType == KEYBOARD_NORMAL)
                m_nKeyboardType = KEYBOARD_SPECIAL1;
            else
                m_nKeyboardType = KEYBOARD_NORMAL;
            [self updateKeyViews];
            break;
        case KEY_SPS:
        case KEY_SPS_IPAD:
            m_nKeyboardType = KEYBOARD_SPECIAL2;
            [self updateKeyViews];
            break;
        case KEY_ABC:
        case KEY_ABC_IPAD:
            m_nKeyboardType = KEYBOARD_NORMAL;
            [self updateKeyViews];
            break;
        case KEY_SPEC123:
        case KEY_SPEC123_IPAD:
            m_nKeyboardType = KEYBOARD_SPECIAL1;
            [self updateKeyViews];
            break;
        case KEY_GLOBE: {
            int kind = (m_nKeyboardKind+1)%KK_COUNT;
            [self changeKeyboardKind:kind];
            [self updateKeyViews];
        }
            break;
        case KEY_RETURN:
            break;
        case KEY_CLOSE_IPAD:
            [m_parent onDone];
            break;
//        case KEY_CAP:
//            break;
//        case KEY_CAP:
//            break;
            
        default:
            break;
    }
}
@end
