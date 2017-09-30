//
//  MainView.h
//  Keyboard
//
//  Created by YCH on 2011.11.02

#import <UIKit/UIKit.h>

@class MainViewController;

//#define PAD_PORT_H        760
#define PAD_PORT_WIDTH    768        
#define PAD_PORT_HEIGHT   264

//#define PAD_LAND_H        416
#define PAD_LAND_WIDTH    1024        
#define PAD_LAND_HEIGHT   352


//#define PHONE_PORT_H        528/2
#define PHONE_PORT_WIDTH    320        
#define PHONE_PORT_HEIGHT   (432/2)

//#define PHONE_LAND_H        316/2
#define PHONE_LAND_WIDTH    ([[UIScreen mainScreen] bounds].size.height)//480        
#define PHONE_LAND_HEIGHT   (324/2)

#define MAX_DRAW            40    

#define NAV_PORT_H          64    
#define NAV_LAND_H          52    

@interface KeyboardView : UIView {
    MainViewController* m_parent;
    
    int     m_nKeyboardKind;
    int     m_nKeyboardType;
    
    UIImageView*        m_imgBg;
    NSMutableArray*     m_aryKey;
    NSMutableArray*		m_arrayPoint;
    
    NSString*           m_sCurString;
    NSMutableString*    m_strText;
    
    //key status
    int                 m_nSelKey;
    BOOL                m_bCaps;
    BOOL                m_bShiftPressed;
    BOOL                m_bIsButton;
    
    BOOL                m_bKeyboardAppear;
    
    float               _PHONE_LAND_WIDTH; //SKY:121023
    
}

@property(nonatomic, retain)    NSString*   m_sCurString;
@property(nonatomic)            BOOL        m_bKeyboardAppear;



-(id)   initView:(MainViewController* )parent;
-(void) CreateKeyViews;
- (void) updateKeyViews;
- (void) changeKeyboardKind:(int)kind;

-(void) setBgImage:(int)kind;
-(int)  GetKeyID:(CGPoint)point;

-(void) InsertText:(NSString*)str;

-(void) MakeString:(NSString*)str;
-(void) delString;

-(void) animationView:(BOOL)bUp;
-(void) layoutSubviews;
-(void) changeOrientation;

//-(void) setTimeDel;
//-(void) delTimerDel;

- (void) onKeyProc:(int)key;
- (bool) isShiftKey:(int)nKey;

@end
