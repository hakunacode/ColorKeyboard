//
//  GameUtils.m
//

#import "GameUtils.h"
#include <sys/time.h>


GameUtils*			g_GameUtils; // = [[GameUtils alloc] init];

@implementation GameUtils

@synthesize m_nOrient;
@synthesize m_fScalH;
@synthesize m_fScalW;
@synthesize m_fWidth;
@synthesize m_fHeight;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) 
    {
	}
	return self;
}

-(void)setScreenValue
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([self isPortraitMode])
        {
            m_fWidth = [[UIScreen mainScreen] bounds].size.width;
            m_fHeight = [[UIScreen mainScreen] bounds].size.height;
            
            m_fScalW = (CGFloat)320/768;
            m_fScalH = (CGFloat)480/1024;
        }
        else
        {
            m_fWidth = [[UIScreen mainScreen] bounds].size.height;
            m_fHeight = [[UIScreen mainScreen] bounds].size.width;
            
            m_fScalW = (CGFloat)480/1024;
            m_fScalH = (CGFloat)320/768;
        }
    }
    else
    {
        if ([self isPortraitMode])
        {
            m_fWidth = [[UIScreen mainScreen] bounds].size.width;
            m_fHeight = [[UIScreen mainScreen] bounds].size.height;
            
            m_fScalW = 1.0;
            m_fScalH = 1.0;
        }
        else
        {
            m_fWidth = [[UIScreen mainScreen] bounds].size.height;
            m_fHeight = [[UIScreen mainScreen] bounds].size.width;
            
            m_fScalW = 1.0;
            m_fScalH = 1.0;
        }
    }
}

- (BOOL)isPortraitMode 
{
	if (m_nOrient == UIInterfaceOrientationPortrait || m_nOrient == UIInterfaceOrientationPortraitUpsideDown)
		return YES;
	return NO;
}

-(UInt32) GetTickCount
{//return mms
	struct timeval tv;	
	if ( gettimeofday(&tv, (struct timezone*)0) )
		return 0;
	return (UInt32)((tv.tv_sec & 0x003FFFFF) * 1000L + tv.tv_usec / 1000L);
}


//image
- (NSString*)stringConvert:(NSString*)strName
{
//    CGFloat screenScale = 1.0f;
//	
//	if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
//		screenScale = [UIScreen mainScreen].scale;
//	}

//    if (screenScale == 1.0f)
//    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            return [NSString stringWithFormat:@"%@.png", strName];
        else
            return [NSString stringWithFormat:@"%@@3x.png", strName];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%@@2x.png", strName];
//    }
}

- (NSString*)stringConvert:(NSString*)strName Extension:(NSString*)strExt
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		return [NSString stringWithFormat:@"%@.%@", strName, strExt];
	else
		return [NSString stringWithFormat:@"%@@3x.%@", strName, strExt];
}

-(BOOL)IsRetina
{
    CGFloat screenScale = 1.0f;
	
	if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
		screenScale = [UIScreen mainScreen].scale;
	}
    
    if (screenScale != 1.0f)
        return YES;
    return NO;
    
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


- (void)dealloc 
{
	[super dealloc];
}

- (BOOL) isiPhonePressedBigKey:(int)key {
    if (key == KEY_CAP || key == KEY_BACKSPACE || key == KEY_123 || key == KEY_ABC || key == KEY_GLOBE || key == KEY_SPACE || key == KEY_RETURN)
        return NO;
    else
        return YES;
}
- (NSString*) getReleasedKeyImagePath:(int)kind key:(int)key {
    NSString* str;//
    int keyboardType = [self getKeyboardTypeWithKey:key];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        switch (keyboardType) {
            case KEYBOARD_NORMAL:
                str = @"KEY_NORMAL";
                break;
            case KEYBOARD_SPECIAL1:
                str = @"SPECIAL_1";
                break;
            case KEYBOARD_SPECIAL2:
                str = @"SPECIAL_2";
                break;
            default:
                break;
        }
    }
    else {
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            switch (keyboardType) {
                case KEYBOARD_NORMAL:
                    str = @"KEY_NORMAL";
                    break;
                case KEYBOARD_SPECIAL1:
                    str = @"SPECIAL_1N";
                    break;
                case KEYBOARD_SPECIAL2:
                    str = @"SPECIAL_2N";
                    break;
                default:
                    break;
            }
        }
        else {
            switch (keyboardType) {
                case KEYBOARD_NORMAL:
                    str = @"KEY_NORMAL";
                    break;
                case KEYBOARD_SPECIAL1:
                    str = @"SPECIAL_1_NORMAL";
                    break;
                case KEYBOARD_SPECIAL2:
                    str = @"SPECIAL_2_NORMAL";
                    break;
                default:
                    break;
            }
        }
    }
    return [NSString stringWithFormat:@"%@/%@", [self getKeyboardRootPath:kind], str];
}
- (NSString*) getPressedKeyImagePath:(int)kind key:(int)key {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([self isiPhonePressedBigKey:key]) {
            str = @"PRESSED_BIG";
        }
        else {
            str = @"KEY_PRESSED";
        }
    }
    else {
        int keyboardType = [self getKeyboardTypeWithKey:key];
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            switch (keyboardType) {
                case KEYBOARD_NORMAL:
                    str = @"KEY_PRESSED";
                    break;
                case KEYBOARD_SPECIAL1:
                    str = @"SPECIAL_1P";
                    break;
                case KEYBOARD_SPECIAL2:
                    str = @"SPECIAL_2P";
                    break;
                default:
                    break;
            }
        }
        else {
            switch (keyboardType) {
                case KEYBOARD_NORMAL:
                    str = @"KEY_PRESSED";
                    break;
                case KEYBOARD_SPECIAL1:
                    str = @"SPECIAL_1_PRESSED";
                    break;
                case KEYBOARD_SPECIAL2:
                    str = @"SPECIAL_2_PRESSED";
                    break;
                default:
                    break;
            }
        }
    }
    return [NSString stringWithFormat:@"%@/%@", [self getKeyboardRootPath:kind], str];
}
- (NSString*) getKeyboardRootPath:(int)kind {
    NSString* strDir;
    NSString* strRoot;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        strDir = @"iPhone_Portrait";
        switch (kind) {
            case KK_BLUE:
                strRoot = @"KB_BLUE_IP";
                break;
            case KK_PINK:
                strRoot = @"KB_PINK_IP";
                break;
            case KK_RAINBOW:
                strRoot = @"KB_RAINBOW_IP";
                break;
            case KK_TYPE:
                strRoot = @"KB_TYPE_IP";
                break;
            case KK_WHITE:
                strRoot = @"KB_WHITE_IP";
                break;
            case KK_WOOD:
                strRoot = @"KB_WOOD_IP";
                break;
            case KK_METAL:
                strRoot = @"KB_METAL_IP";
                break;
            case KK_METRO:
                strRoot = @"KB_METRO_IP";
                break;
            case KK_NEON:
                strRoot = @"KB_NEON_IP";
                break;
            case KK_OLD:
                strRoot = @"KB_OLD_IP";
                break;
            default:
                break;
        }
    }
    else {
        if (UIInterfaceOrientationIsLandscape(m_nOrient) == YES) {
            strDir = @"iPad_Landscape";
            switch (kind) {
                case KK_BLUE:
                    strRoot = @"KB_IPAD_BLUE_LS";
                    break;
                case KK_PINK:
                    strRoot = @"KB_IPAD_PINK_LS";
                    break;
                case KK_RAINBOW:
                    strRoot = @"KB_IPAD_RAINBOW_LS";
                    break;
                case KK_TYPE:
                    strRoot = @"KB_IPAD_METRO_LS";//kgh
                    break;
                case KK_WHITE:
                    strRoot = @"KB_IPAD_PINK_LS";//kgh
                    break;
                case KK_WOOD:
                    strRoot = @"KB_IPAD_WOOD_LS";
                    break;
                case KK_METAL:
                    strRoot = @"KB_IPAD_METAL_LS";
                    break;
                case KK_METRO:
                    strRoot = @"KB_IPAD_METRO_LS";
                    break;
                case KK_NEON:
                    strRoot = @"KB_IPAD_NEON_LS";
                    break;
                case KK_OLD:
                    strRoot = @"KB_IPAD_OLD_LS";
                    break;
                default:
                    break;
            }
        }
        else {
            strDir = @"iPad_Portrait";
            switch (kind) {
                case KK_BLUE:
                    strRoot = @"IPAD_KBPT_BLUE";
                    break;
                case KK_PINK:
                    strRoot = @"IPAD_KBPT_PINK";
                    break;
                case KK_RAINBOW:
                    strRoot = @"IPAD_KBPT_RAINBOW";
                    break;
                case KK_TYPE:
                    strRoot = @"IPAD_KBPT_TYPE";
                    break;
                case KK_WHITE:
                    strRoot = @"IPAD_KBPT_WHITE";
                    break;
                case KK_WOOD:
                    strRoot = @"IPAD_KBPT_WOOD";
                    break;
                case KK_METAL:
                    strRoot = @"IPAD_KBPT_METAL";
                    break;
                case KK_METRO:
                    strRoot = @"IPAD_KBPT_METRO";
                    break;
                case KK_NEON:
                    strRoot = @"IPAD_KBPT_NEON";
                    break;
                case KK_OLD:
                    strRoot = @"IPAD_KBPT_OLD";
                    break;
                default:
                    break;
            }
        }
    }
    return [NSString stringWithFormat:@"keyboard/%@/%@", strDir, strRoot];
}
- (NSString*) getKeyboardStatePath:(int)kind {
    return nil;
}

- (NSString*) getKeyImageName:(int)key state:(int)state {
    return nil;
}
- (NSString*) getNormalKeyImageName:(int)key {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        str = [self getiPhonePortraitNormalKeyImageName:key];
    }
    else {
        str = [self getiPadNormalKeyImageName:key];
    }
    return str;
}
- (NSString*) getPressedKeyImageName:(int)key {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        str = [self getiPhonePortraitPressedKeyImageName:key];
    }
    else {
        str = [self getiPadPressedKeyImageName:key];
    }
    return str;
}
- (NSString*) getiPhonePortraitNormalKeyImageName:(int)key {
    NSString* str;
    int index;
    int type = [self getKeyboardTypeWithKey:key];
    switch (type) {
        case KEYBOARD_NORMAL:
            index = [self getNormalKeyImageIndex:key];
            str = [NSString stringWithFormat:@"KEY_NORMAL_%02d", index];
            break;
        case KEYBOARD_SPECIAL1:
            index = [self getSpecial1KeyImageIndex:key];
            str = [NSString stringWithFormat:@"SPECIAL_1_%02d", index];
            break;
        case KEYBOARD_SPECIAL2:
            index = [self getSpecial2KeyImageIndex:key];
            str = [NSString stringWithFormat:@"SPECIAL_2_%02d", index];
            break;
        default:
            break;
    }
    return str;
}
- (NSString*) getiPhonePortraitPressedKeyImageName:(int)key {
    NSString* str;
    if ([self isiPhonePressedBigKey:key]) {
        int index = 0;
        if (key >= KEY_Q && key <= KEY_L)
            index = key - KEY_Q + 1;
        else if (key >= KEY_Z && key <= KEY_M)
            index = key - KEY_Z + 21;
        else if (key >= KEY_1 && key <= KEY_QUOTATION)
            index = key - KEY_1 + 30;
        else if (key >= KEY_DOT && key <= KEY_UPPERCOMMA)
            index = key - KEY_DOT + 50;
        else if (key == KEY_ABC)
            index = 60;
        else if (key >= KEY_BRACKET_START && key <= KEY_CENTERDOT_IPHONE)
            index = key - KEY_BRACKET_START + 60;
        str = [NSString stringWithFormat:@"PRESSED_BIG_%02d", index];
    }
    else {
        str = [NSString stringWithFormat:@"KEY_PRESSED_%02d", [self getNormalKeyImageIndex:key]];
    }
    return str;
}
- (NSString*) getiPadNormalKeyImageName:(int)key {
    NSString* str;
    int index;
    int type = [self getKeyboardTypeWithKey:key];
    if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
        switch (type) {
            case KEYBOARD_NORMAL:
                index = [self getNormalKeyImageIndex:key];
                str = [NSString stringWithFormat:@"KEY_NORMAL_%02d", index];
                break;
            case KEYBOARD_SPECIAL1:
                index = [self getSpecial1KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_1N_%02d", index];
                break;
            case KEYBOARD_SPECIAL2:
                index = [self getSpecial2KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_2N_%02d", index];
                break;
            default:
                break;
        }
    }
    else {
        switch (type) {
            case KEYBOARD_NORMAL:
                index = [self getNormalKeyImageIndex:key];
                str = [NSString stringWithFormat:@"KEY_NORMAL_%02d", index];
                break;
            case KEYBOARD_SPECIAL1:
                index = [self getSpecial1KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_1_NORMAL_%02d", index];
                break;
            case KEYBOARD_SPECIAL2:
                index = [self getSpecial2KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_2_NORMAL_%02d", index];
                break;
            default:
                break;
        }
    }
    return str;
}
- (NSString*) getiPadPressedKeyImageName:(int)key {
    NSString* str;
    int index;
    int type = [self getKeyboardTypeWithKey:key];
    if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
        switch (type) {
            case KEYBOARD_NORMAL:
                index = [self getNormalKeyImageIndex:key];
                str = [NSString stringWithFormat:@"KEY_PRESSED_%02d", index];
                break;
            case KEYBOARD_SPECIAL1:
                index = [self getSpecial1KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_1P_%02d", index];
                break;
            case KEYBOARD_SPECIAL2:
                index = [self getSpecial2KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_2P_%02d", index];
                break;
            default:
                break;
        }
    }
    else {
        switch (type) {
            case KEYBOARD_NORMAL:
                index = [self getNormalKeyImageIndex:key];
                str = [NSString stringWithFormat:@"KEY_PRESSED_%02d", index];
                break;
            case KEYBOARD_SPECIAL1:
                index = [self getSpecial1KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_1_PRESSED_%02d", index];
                break;
            case KEYBOARD_SPECIAL2:
                index = [self getSpecial2KeyImageIndex:key];
                str = [NSString stringWithFormat:@"SPECIAL_2_PRESSED_%02d", index];
                break;
            default:
                break;
        }
    }
    return str;
}

- (int) getKeyboardTypeWithKey:(int)key {
    int type = KEYBOARD_NORMAL;
    if (key >= KEY_1 && key <= KEY_ABC_IPAD)
        type = KEYBOARD_SPECIAL1;
    else if (key >= KEY_BRACKET_START)
        type = KEYBOARD_SPECIAL2;
    return type;
}
- (BOOL) isEnableKeyWithType:(int)type key:(int)key {
    int nKeyboardType = [self getKeyboardTypeWithKey:key];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (key == KEY_GLOBE || key == KEY_SPACE || key == KEY_RETURN || key == KEY_BACKSPACE)
            return YES;
        if ((key == KEY_ABC) && (type == KEYBOARD_SPECIAL1 || type == KEYBOARD_SPECIAL2))
            return YES;
        if ((key >= KEY_DOT && key <= KEY_UPPERCOMMA) && (type == KEYBOARD_SPECIAL1 || type == KEYBOARD_SPECIAL2))
            return YES;
        if (nKeyboardType == type)
            return YES;
    }
    else {
        if (key == KEY_GLOBE || key == KEY_SPACE || key == KEY_RETURN || key == KEY_BACKSPACE || key == KEY_CLOSE_IPAD)
            return YES;
        if (((key >= KEY_DOT && key <= KEY_UPPERCOMMA) || (key == KEY_QUOTATION) || (key == KEY_ABC || key == KEY_ABC_IPAD)) && (type == KEYBOARD_SPECIAL1 || type == KEYBOARD_SPECIAL2))
            return YES;
        if (nKeyboardType == type)
            return YES;
    }
    return NO;
}
- (int) getNormalKeyImageIndex:(int)key {
    int index = key - KEY_Q;
    int nRet;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        int keyIndexs[] = {
            2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // Q, W, E, R, T, Y, U, I, O, P
            14, 15, 16, 17, 18, 19, 20, 21, 22, // A, S, D, F, G, H, J, K, L
            27, 28, 29, 30, 31, 32, 33, // Z, X, C, V, B, N, M
            25, 35, 37, 38, 39, 40, //CAP, BACKSPACE, 123, GLOBE, SPACE, RETURN
        };
        nRet = keyIndexs[index];
    }
    else {
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // Q, W, E, R, T, Y, U, I, O, P
                14, 15, 16, 17, 18, 19, 20, 21, 22, // A, S, D, F, G, H, J, K, L
                25, 26, 27, 28, 29, 30, 31, // Z, X, C, V, B, N, M
                24, 12, 35, 36, 37, 23, //CAP, BACKSPACE, 123, GLOBE, SPACE, RETURN
                32, 33, 34, 38, 39, //for iPad : EXCLAMATION, QUESTION, CAP, 123, CLOSE
            };
            nRet = keyIndexs[index];
        }
        else {
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // Q, W, E, R, T, Y, U, I, O, P
                14, 15, 16, 17, 18, 19, 20, 21, 22, // A, S, D, F, G, H, J, K, L
                34, 35, 25, 26, 27, 28, 29, // Z, X, C, V, B, N, M
                33, 12, 36, 37, 38, 23, //CAP, BACKSPACE, 123, GLOBE, SPACE, RETURN
                30, 31, 32, 39, 40, //for iPad : EXCLAMATION, QUESTION, CAP, 123, CLOSE
            };
            nRet = keyIndexs[index];
        }
    }
    return nRet;
}
- (int) getSpecial1KeyImageIndex:(int)key {
    int index = key - KEY_1;
    int nRet;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        int keyIndexs[] = {
            2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
            13, 14, 15, 16, 17, 18, 19, 20, 21, 22, // -, /, :, ;, (, ), $, &, @, "
            24, 26, 27, 28, 29, 30, 60, // #+=, ., ,, ?, !, ',abc
        };
        nRet = keyIndexs[index];
    }
    else {
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
                14, 22, 23, 24, 16, 17, 18, 19, 20, 32, // -, /, :, ;, (, ), $, &, @, "
                25, 27, 28, 29, 30, 31, 35,// #+=, ., ,, ?, !, ', ABC
                34, 26, 38, //for iPad : #+=, undo, ABC
            };
            nRet = keyIndexs[index];
        }
        else {
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
                14, 15, 16, 17, 18, 19, 20, 21, 22, 37, // -, /, :, ;, (, ), $, &, @, "
                33, 25, 35, 27, 36, 29, 39,// #+=, ., ,, ?, !, ', ABC
                38, 34, 42, //for iPad : #+=, undo, ABC
            };
            nRet = keyIndexs[index];
        }
    }
    return nRet;
}
- (int) getSpecial2KeyImageIndex:(int)key {
    int index = key - KEY_BRACKET_START;
    int nRet;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        int keyIndexs[] = {
            2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // [, ], {, }, #, %, ^, *, +, =
            13, 14, 15, 16, 17, 18, 19, 20, 21, 22, // _, \, |, ~, <, >, , , , 
            24, // 123,
        };
        nRet = keyIndexs[index];
    }
    else {
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // [, ], {, }, #, %, ^, *, +, =
                14, 22, 23, 24, 16, 17, 18, 19, 20, 20, 25,// _, \, |, ~, <, >, , , , 123,
                34, 26,//for ipad : 123, redo
            };
            nRet = keyIndexs[index];
        }
        else{
            int keyIndexs[] = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, // [, ], {, }, #, %, ^, *, +, =
                14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 33, // _, \, |, ~, <, >, , , , 123,
                38, 34,//for ipad : 123, redo
            };
            nRet = keyIndexs[index];
        }
    }
    return nRet;
}
- (CGSize) getKeySize:(int)key {
    CGSize size;
    CGFloat height = 46;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        switch (key) {
            case KEY_CAP:
            case KEY_BACKSPACE:
            case KEY_SPS://special-1
            case KEY_DOT:
            case KEY_COMMA:
            case KEY_QUESTIONMARK:
            case KEY_EXCLAMATIONMARK:
            case KEY_UPPERCOMMA:
            case KEY_SPEC123:
                size = CGSizeMake(44, height);
                break;
            case KEY_123:
            case KEY_ABC:
                size = CGSizeMake(41, height);
                break;
            case KEY_GLOBE:
                size = CGSizeMake(40, height);
                break;
            case KEY_SPACE:
                size = CGSizeMake(160, height);
                break;
            case KEY_RETURN:
                size = CGSizeMake(80, height);
                break;
            default:
                size = CGSizeMake(32, height);
                break;
        }
    }
    else {
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES) {
            height = 65;
            switch (key) {
                case KEY_123:
                case KEY_ABC:
                    size = CGSizeMake(115, height);
                    break;
                case KEY_SPACE:
                    size = CGSizeMake(406, height);
                    break;
                case KEY_CAP:
                    size = CGSizeMake(67, height);
                    break;
                case KEY_CAP_IPAD:
                    size = CGSizeMake(72.6, height);
                    break;
                case KEY_GLOBE:
                case KEY_123_IPAD:
                case KEY_SPS_IPAD:
                case KEY_ABC_IPAD:
                    size = CGSizeMake(89, height);
                    break;
                case KEY_UNDO_IPAD:
                case KEY_REDO_IPAD:
                    size = CGSizeMake(136, height);
                    break;
                case KEY_RETURN:
                    size = CGSizeMake(118, height);
                    break;
                default:
                    size = CGSizeMake(69.8f, height);
                    break;
            }
        }
        else {
            height = 86;
            switch (key) {
                case KEY_123:
                case KEY_ABC:
                    size = CGSizeMake(153, height);
                    break;
                case KEY_SPACE:
                    size = CGSizeMake(542, height);
                    break;
                case KEY_CAP:
                    size = CGSizeMake(89, height);
                    break;
                case KEY_CAP_IPAD:
                    size = CGSizeMake(97, height);
                    break;
                case KEY_GLOBE:
                case KEY_123_IPAD:
                case KEY_SPS_IPAD:
                case KEY_ABC_IPAD:
                    size = CGSizeMake(119, height);
                    break;
                case KEY_UNDO_IPAD:
                case KEY_REDO_IPAD:
                    size = CGSizeMake(181, height);
                    break;
                case KEY_RETURN:
                    size = CGSizeMake(158, height);
                    break;
                default:
                    size = CGSizeMake(93.0f, height);
                    break;
            }
        }
    }
    return size;
}
- (CGPoint) getKeyPosition:(int)key {
    CGFloat x = -100, y = -100;
    CGSize size = [self getKeySize:key];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ((key >= KEY_Q && key <= KEY_P) || (key >= KEY_1 && key <= KEY_0) || (key >= KEY_BRACKET_START && key <= KEY_EQUALSIGN)) {
            int startKey;
            if (key >= KEY_Q && key <= KEY_P)
                startKey = KEY_Q;
            else if (key >= KEY_1 && key <= KEY_0)
                startKey = KEY_1;
            else
                startKey = KEY_BRACKET_START;
            x = (key-startKey)*(size.width);
            y = 8;
        }
        else if (key >= KEY_A && key <= KEY_L) {
            x = 16+(key-KEY_A)*(size.width);
            y = 54+8;
        }
        else if ((key >= KEY_Z && key <= KEY_M) || (key >= KEY_DOT && key <= KEY_UPPERCOMMA)) {
            int startKey;
            if (key >= KEY_Z && key <= KEY_M)
                startKey = KEY_Z;
            else
                startKey = KEY_DOT;
            x = 48+(key-startKey)*(size.width);
            y = 108+8;
        }
        else if (key == KEY_CAP || key == KEY_SPS || key == KEY_SPEC123) {
            x = 0;
            y = 108+8;
        }
        else if (key == KEY_BACKSPACE) {
            x = m_fWidth-size.width;
            y = 108+8;
        }
        else if (key == KEY_123 || key == KEY_ABC) {
            x = 0;
            y = 162+8;
        }
        else if (key == KEY_GLOBE) {
            x = 41;
            y = 162+8;
        }
        else if (key == KEY_SPACE) {
            x = 81;
            y = 162+8;
        }
        else if (key == KEY_RETURN) {
            x = 241;
            y = 162+8;
        }
        else if ((key >= KEY_DASH && key <= KEY_QUOTATION) || (key >= KEY_UNDERLINE && key <= KEY_CENTERDOT_IPHONE)) {
            int startKey;
            if (key >= KEY_DASH && key <= KEY_QUOTATION)
                startKey = KEY_DASH;
            else
                startKey = KEY_UNDERLINE;
            x = (key-startKey)*(size.width);
            y = 54+8;
        }
        else if (key >= KEY_DOT && key <= KEY_UPPERCOMMA) {
        }
    }
    else {
        CGFloat offsetY = 2;
        if (UIInterfaceOrientationIsPortrait(m_nOrient) == YES || YES) {
            offsetY = 0;
            if ((key >= KEY_Q && key <= KEY_P) || (key >= KEY_1 && key <= KEY_0) || (key >= KEY_BRACKET_START && key <= KEY_EQUALSIGN)) {
                int startKey;
                if (key >= KEY_Q && key <= KEY_P)
                    startKey = KEY_Q;
                else if (key >= KEY_1 && key <= KEY_0)
                    startKey = KEY_1;
                else
                    startKey = KEY_BRACKET_START;
                x = (key-startKey)*(size.width);
                y = offsetY;
            }
            else if (key == KEY_BACKSPACE) {
                x = m_fWidth-size.width;
                y = offsetY;
            }
            else if ((key >= KEY_A && key <= KEY_L) || (key >= KEY_DASH && key <= KEY_AUTOMARK) || (key >= KEY_UNDERLINE && key <= KEY_ENMARK)) {//line
                int startKey;
                if (key >= KEY_A && key <= KEY_L)
                    startKey = KEY_A;
                else if (key >= KEY_DASH && key <= KEY_QUOTATION)
                    startKey = KEY_DASH;
                else
                    startKey = KEY_UNDERLINE;
                x = size.width/3+(key-startKey)*(size.width);
                y = size.height+offsetY*2;
            }
            else if (key == KEY_RETURN) {
                x = m_fWidth-size.width;
                y = size.height+offsetY*2;
            }
            else if (key >= KEY_Z && key <= KEY_M) {
                CGSize sizeCap = [self getKeySize:KEY_CAP];
                x = sizeCap.width+(key-KEY_Z)*(size.width);
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_CAP || key == KEY_SPS || key == KEY_SPEC123) {
                x = 0;
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_EXCLAMATION_IPAD || key == KEY_QUESTION_IPAD) {
                x = (key-KEY_EXCLAMATION_IPAD+8)*(size.width);
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_CAP_IPAD || key == KEY_SPS_IPAD || key == KEY_SPEC123_IPAD) {
                x = m_fWidth-size.width;
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_UNDO_IPAD || key == KEY_REDO_IPAD) {
                CGSize sizeN = [self getKeySize:KEY_SPS];
                x = sizeN.width;
                y = size.height*2+offsetY*3;
            }
            else if (key >= KEY_DOT && key <= KEY_UPPERCOMMA) {
                x = (key-KEY_DOT+3)*(size.width);
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_QUOTATION) {
                x = 8*(size.width);
                y = size.height*2+offsetY*3;
            }
            else if (key == KEY_123 || key == KEY_ABC) {//line-3
                x = 0;
                y = size.height*3+offsetY*4;
            }
            else if (key == KEY_GLOBE) {
                CGSize sizeN = [self getKeySize:KEY_123];
                x = sizeN.width;
                y = size.height*3+offsetY*4;
            }
            else if (key == KEY_SPACE) {
                CGSize size123 = [self getKeySize:KEY_123];
                CGSize sizeGlobe = [self getKeySize:KEY_GLOBE];
                x = size123.width+sizeGlobe.width;
                y = size.height*3+offsetY*4;
            }
            else if (key == KEY_123_IPAD || key == KEY_ABC_IPAD) {
                CGSize sizeClose = [self getKeySize:KEY_CLOSE_IPAD];
                x = m_fWidth - size.width - sizeClose.width;
                y = size.height*3+offsetY*4;
            }
            else if (key == KEY_CLOSE_IPAD) {
                x = m_fWidth - size.width;
                y = size.height*3+offsetY*4;
            }
            else {
                NSLog(@"error - key position(%d)", key);
            }
        }
        else {//kgh
            if ((key >= KEY_Q && key <= KEY_P) || (key >= KEY_1 && key <= KEY_0) || (key >= KEY_BRACKET_START && key <= KEY_EQUALSIGN)) {
                int startKey;
                if (key >= KEY_Q && key <= KEY_P)
                    startKey = KEY_Q;
                else if (key >= KEY_1 && key <= KEY_0)
                    startKey = KEY_1;
                else
                    startKey = KEY_BRACKET_START;
                x = (key-startKey)*(size.width);
                y = 4;
            }
            else if (key == KEY_BACKSPACE) {
                x = m_fWidth-size.width;
                y = 4;
            }
            else if ((key >= KEY_A && key <= KEY_L) || (key >= KEY_DASH && key <= KEY_AUTOMARK) || (key >= KEY_UNDERLINE && key <= KEY_ENMARK)) {
                int startKey;
                if (key >= KEY_A && key <= KEY_L)
                    startKey = KEY_A;
                else if (key >= KEY_DASH && key <= KEY_QUOTATION)
                    startKey = KEY_DASH;
                else
                    startKey = KEY_UNDERLINE;
                x = size.width/2+(key-startKey)*(size.width);
                y = size.height+8;
            }
            else if (key == KEY_RETURN) {
                x = m_fWidth-size.width;
                y = size.height+8;
            }
            else if (key >= KEY_Z && key <= KEY_M) {
                x = size.width+(key-KEY_Z)*(size.width);
                y = size.height*2+12;
            }
            else if (key == KEY_CAP || key == KEY_SPS || key == KEY_SPEC123) {
                x = 0;
                y = size.height*2+12;
            }
            else if (key == KEY_EXCLAMATION_IPAD || key == KEY_QUESTION_IPAD) {
                x = (key-KEY_EXCLAMATION_IPAD+8)*(size.width);
                y = size.height*2+12;
            }
            else if (key == KEY_CAP_IPAD || key == KEY_SPS_IPAD || key == KEY_SPEC123_IPAD) {
                x = m_fWidth-size.width;
                y = size.height*2+12;
            }
            else if (key == KEY_UNDO_IPAD || key == KEY_REDO_IPAD) {
                CGSize sizeN = [self getKeySize:KEY_SPS];
                x = sizeN.width;
                y = size.height*2+12;
            }
            else if (key >= KEY_DOT && key <= KEY_UPPERCOMMA) {
                x = (key-KEY_DOT+3)*(size.width);
                y = size.height*2+12;
            }
            else if (key == KEY_QUOTATION) {
                x = 8*(size.width);
                y = size.height*2+12;
            }
            else if (key == KEY_123 || key == KEY_ABC) {//line-3
                x = 0;
                y = size.height*3+16;
            }
            else if (key == KEY_GLOBE) {
                CGSize sizeN = [self getKeySize:KEY_123];
                x = sizeN.width;
                y = size.height*3+16;
            }
            else if (key == KEY_SPACE) {
                CGSize size123 = [self getKeySize:KEY_123];
                CGSize sizeGlobe = [self getKeySize:KEY_GLOBE];
                x = size123.width+sizeGlobe.width;
                y = size.height*3+16;
            }
            else if (key == KEY_123_IPAD || key == KEY_ABC_IPAD) {
                CGSize sizeClose = [self getKeySize:KEY_CLOSE_IPAD];
                x = m_fWidth - size.width - sizeClose.width;
                y = size.height*3+16;
            }
            else if (key == KEY_CLOSE_IPAD) {
                x = m_fWidth - size.width;
                y = size.height*3+16;
            }
            else {
                NSLog(@"error - key position(%d)", key);
            }
        }
    }
    return CGPointMake(x, y);
}

- (NSString*) getKeyString:(int)key bCaps:(bool)bCaps{
    NSString* str;
    switch (key)
    {
        case KEY_Q:       str = bCaps ? @"Q":@"q";       break;
        case KEY_W:       str = bCaps ? @"W":@"w";       break;
        case KEY_E:       str = bCaps ? @"E":@"e";       break;
        case KEY_R:       str = bCaps ? @"R":@"r";       break;
        case KEY_T:       str = bCaps ? @"T":@"t";       break;
        case KEY_Y:       str = bCaps ? @"Y":@"y";       break;
        case KEY_U:       str = bCaps ? @"U":@"u";       break;
        case KEY_I:       str = bCaps ? @"I":@"i";       break;
        case KEY_O:       str = bCaps ? @"O":@"o";       break;
        case KEY_P:       str = bCaps ? @"P":@"p";       break;
        case KEY_A:       str = bCaps ? @"A":@"a";       break;
        case KEY_S:       str = bCaps ? @"S":@"s";       break;
        case KEY_D:       str = bCaps ? @"D":@"d";       break;
        case KEY_F:       str = bCaps ? @"F":@"f";       break;
        case KEY_G:       str = bCaps ? @"G":@"g";       break;
        case KEY_H:       str = bCaps ? @"H":@"h";       break;
        case KEY_J:       str = bCaps ? @"J":@"j";       break;
        case KEY_K:       str = bCaps ? @"K":@"k";       break;
        case KEY_L:       str = bCaps ? @"L":@"l";       break;
        case KEY_Z:       str = bCaps ? @"Z":@"z";       break;
        case KEY_X:       str = bCaps ? @"X":@"x";       break;
        case KEY_C:       str = bCaps ? @"C":@"c";       break;
        case KEY_V:       str = bCaps ? @"V":@"v";       break;
        case KEY_B:       str = bCaps ? @"B":@"b";       break;
        case KEY_N:       str = bCaps ? @"N":@"n";       break;
        case KEY_M:       str = bCaps ? @"M":@"m";       break;
        case KEY_SPACE:   str = @" ";       break;
        case KEY_RETURN:  str = @"\n";      break;
        case KEY_1:       str = @"1";       break;
        case KEY_2:       str = @"2";       break;
        case KEY_3:       str = @"3";       break;
        case KEY_4:       str = @"4";       break;
        case KEY_5:       str = @"5";       break;
        case KEY_6:       str = @"6";       break;
        case KEY_7:       str = @"7";       break;
        case KEY_8:       str = @"8";       break;
        case KEY_9:       str = @"9";       break;
        case KEY_0:       str = @"0";       break;
        case KEY_DASH:    str = @"-";       break;
        case KEY_SLASH:   str = @"/";       break;
        case KEY_COLON:   str = @":";       break;
        case KEY_SEMICOLON:             str = @";";       break;
        case KEY_PARENTHESIS_START:     str = @"(";       break;
        case KEY_PARENTHESIS_END:       str = @")";       break;
        case KEY_DOLLAR: str = @"$";       break;
        case KEY_AND:    str = @"&";       break;
        case KEY_AUTOMARK:       str = @"@";       break;
        case KEY_QUOTATION:       str = @"\"";       break;
        case KEY_DOT:       str = @".";       break;
        case KEY_COMMA:       str = @",";       break;
        case KEY_QUESTIONMARK:       str = @"?";       break;
        case KEY_EXCLAMATIONMARK:       str = @"!";       break;
        case KEY_UPPERCOMMA:       str = @"'";       break;
        case KEY_BRACKET_START:       str = @"[";       break;
        case KEY_BRACKET_END:       str = @"]";       break;
        case KEY_BARCE_START:       str = @"{";       break;
        case KEY_BARCE_END:       str = @"}";       break;
        case KEY_SHAPE:       str = @"#";       break;
        case KEY_PERCENT:       str = @"%";       break;
        case KEY_XOR:       str = @"^";       break;
        case KEY_MULTIPLESIGN:       str = @"*";       break;
        case KEY_PLUS:       str = @"+";       break;
        case KEY_EQUALSIGN:       str = @"=";       break;
        case KEY_UNDERLINE:       str = @"_";       break;
        case KEY_OBLIQUE:       str = @"\\";       break;
        case KEY_LINE:       str = @"|";       break;
        case KEY_WAVYMARK:       str = @"~";       break;
        case KEY_BIGMARK:       str = @"<";       break;
        case KEY_SMALLMARK:       str = @">";       break;
        case KEY_EUROMARK:       str = @"€";       break;
        case KEY_POUNDMARK:       str = @"£";       break;
        case KEY_ENMARK:       str = @"¥";       break;
        case KEY_CENTERDOT_IPHONE:       str = @"•";       break;
        default:
            str = @"";//return
            break;
    }
    return str;
}
- (BOOL) isOnlyiPhoneKey:(int)key {
    return (key == KEY_CENTERDOT_IPHONE);
}
- (BOOL) isOnlyiPadKey:(int)key {
    if (key == KEY_EXCLAMATION_IPAD || key == KEY_QUESTION_IPAD || key == KEY_CAP_IPAD || key == KEY_123_IPAD || key == KEY_CLOSE_IPAD || key == KEY_SPS_IPAD || key == KEY_UNDO_IPAD || key == KEY_ABC_IPAD || key == KEY_SPEC123_IPAD || key == KEY_REDO_IPAD)
        return YES;
    return NO;
}

@end
