//
//  GameUtils.h
//
//  Created by YCH on 11/09/02.

#import <Foundation/Foundation.h>

//#define LOGVIEW     1

enum KEY_TYPE {
    KEY_Q = 0,
    KEY_W,
    KEY_E,
    KEY_R,
    KEY_T,
    KEY_Y,
    KEY_U,
    KEY_I,
    KEY_O,
    KEY_P,
    KEY_A,
    KEY_S,
    KEY_D,
    KEY_F,
    KEY_G,
    KEY_H,
    KEY_J,
    KEY_K,
    KEY_L,
    KEY_Z,
    KEY_X,
    KEY_C,
    KEY_V,
    KEY_B,
    KEY_N,
    KEY_M,
    KEY_CAP,
    KEY_BACKSPACE,
    KEY_123,
    KEY_GLOBE,
    KEY_SPACE,
    KEY_RETURN,
    KEY_EXCLAMATION_IPAD,//for iPad
    KEY_QUESTION_IPAD,//for iPad
    KEY_CAP_IPAD,//for iPad
    KEY_123_IPAD,//for iPad
    KEY_CLOSE_IPAD,//for iPad
    KEY_1,//SPECIAL1
    KEY_2,
    KEY_3,
    KEY_4,
    KEY_5,
    KEY_6,
    KEY_7,
    KEY_8,
    KEY_9,
    KEY_0,
    KEY_DASH,// - 
    KEY_SLASH,// /
    KEY_COLON,// :
    KEY_SEMICOLON,
    KEY_PARENTHESIS_START,//(
    KEY_PARENTHESIS_END,
    KEY_DOLLAR,
    KEY_AND,
    KEY_AUTOMARK,
    KEY_QUOTATION,// "
    KEY_SPS,//#+=
    KEY_DOT,//.
    KEY_COMMA,//,
    KEY_QUESTIONMARK, // ?
    KEY_EXCLAMATIONMARK,//!
    KEY_UPPERCOMMA,//'
    KEY_ABC,
    KEY_SPS_IPAD,//for iPad #+=
    KEY_UNDO_IPAD,//for iPad 
    KEY_ABC_IPAD,//for iPad 
    KEY_BRACKET_START,//[ - SPECIAL2
    KEY_BRACKET_END,//]
    KEY_BARCE_START,// {
    KEY_BARCE_END,// }
    KEY_SHAPE,
    KEY_PERCENT,
    KEY_XOR,// ^
    KEY_MULTIPLESIGN,// *
    KEY_PLUS,
    KEY_EQUALSIGN,// = 
    KEY_UNDERLINE,
    KEY_OBLIQUE,// \-
    KEY_LINE,// |
    KEY_WAVYMARK,//~
    KEY_BIGMARK,//>
    KEY_SMALLMARK,//<
    KEY_EUROMARK,
    KEY_POUNDMARK,
    KEY_ENMARK,
    KEY_CENTERDOT_IPHONE,//for iphone
    KEY_SPEC123,
    KEY_SPEC123_IPAD,//for ipad
    KEY_REDO_IPAD,//for ipad
    KEY_COUNT
};

enum KEY_STATE {
    KS_RELEASED = 0,
    KS_PRESSED
};

enum KEYBOARD_TYPE {
    KEYBOARD_NORMAL = 1,
    KEYBOARD_SPECIAL1 = 2,
    KEYBOARD_SPECIAL2 = 4,
};

enum KEYBOARD_STATE {
    KEYBOARD_IPHONE_PORTRAIT = 0,
    KEYBOARD_IPHONE_LANDSCAPE,
    KEYBOARD_IPAD_PORTRAIT,
    KEYBOARD_IPAD_LANDSCAPE
};

enum KEYBOARD_KIND {
    KK_BLUE = 0,
    KK_PINK,
    KK_RAINBOW,
    KK_TYPE,
    KK_WHITE,
    KK_WOOD,
    KK_METAL,
    KK_METRO,
    KK_NEON,
    KK_OLD,
    KK_COUNT
};

@interface GameUtils : NSObject
{
    UIInterfaceOrientation	m_nOrient;	
    CGFloat     m_fScalW;
    CGFloat     m_fScalH;
    CGFloat     m_fWidth;
    CGFloat     m_fHeight;

}
@property (nonatomic) UIInterfaceOrientation	m_nOrient;
@property (nonatomic) CGFloat	m_fScalW;
@property (nonatomic) CGFloat	m_fScalH;
@property (nonatomic) CGFloat	m_fWidth;
@property (nonatomic) CGFloat	m_fHeight;

-(UInt32)       GetTickCount;
-(NSString*)    stringConvert:(NSString*)strName;
-(NSString*)    stringConvert:(NSString*)strName Extension:(NSString*)strExt;
-(BOOL)         IsRetina;
-(BOOL)         isPortraitMode; 
-(void)         setScreenValue;

- (NSString*) getReleasedKeyImagePath:(int)kind key:(int)key;
- (NSString*) getPressedKeyImagePath:(int)kind key:(int)key;
- (NSString*) getKeyboardRootPath:(int)kind;
- (NSString*) getKeyboardStatePath:(int)kind;

- (NSString*) getKeyImageName:(int)key state:(int)state;
- (NSString*) getNormalKeyImageName:(int)key;
- (NSString*) getPressedKeyImageName:(int)key;
- (NSString*) getiPhonePortraitNormalKeyImageName:(int)key;
- (NSString*) getiPhonePortraitPressedKeyImageName:(int)key;
- (NSString*) getiPadNormalKeyImageName:(int)key;
- (NSString*) getiPadPressedKeyImageName:(int)key;

- (int) getKeyboardTypeWithKey:(int)key;
- (int) getNormalKeyImageIndex:(int)key;
- (int) getSpecial1KeyImageIndex:(int)key;
- (int) getSpecial2KeyImageIndex:(int)key;
- (BOOL) isiPhonePressedBigKey:(int)key;
- (BOOL) isEnableKeyWithType:(int)type key:(int)key;

- (CGSize) getKeySize:(int)key;
- (CGPoint) getKeyPosition:(int)key;

- (NSString*) getKeyString:(int)key bCaps:(bool)bCaps;
- (BOOL) isOnlyiPhoneKey:(int)key;
- (BOOL) isOnlyiPadKey:(int)key;

@end

extern GameUtils*	g_GameUtils;


#define ccpFlip(__X__,__Y__) CGPointMake(__X__,[[CCDirector sharedDirector] winSize].height - __Y__)