//
//  MainViewController.h
//  ColorKeyboard
//
//  Created by admin on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#ifdef ADS_MOBCLIX
#import "MobclixAdView.h"
#endif

@class LinesView;
@class KeyboardView;

@interface MainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate> {
    IBOutlet UITextView*    m_txtView;
    IBOutlet UIToolbar*     m_toolBar;
    IBOutlet LinesView*     linesView;
    KeyboardView*           m_keyboardView;
    UISwitch*               m_switchEff;
    
    BOOL                    m_bIsSending;
    BOOL                    m_bFindDic;
    BOOL                    m_bCustom;
    
    UIView*                 m_posKeyboard;
    
    NSString*   m_strInit;
    NSString*   m_strFinal;
    
#ifdef ADS_MOBCLIX
@private
	MobclixAdView*          adView;
    
	BOOL	m_bMobclixTop;
	BOOL	m_bMobclixShow;
#endif
}

#ifdef ADS_MOBCLIX
@property(nonatomic,retain) MobclixAdView* adView;
#endif

@property (nonatomic, retain) IBOutlet LinesView *linesView;
@property (nonatomic, retain) IBOutlet UITextView *m_txtView;
@property (nonatomic, retain) IBOutlet UIToolbar *m_toolBar;
@property (nonatomic)                   BOOL  m_bFindDic;
@property (nonatomic)                   BOOL  m_bCustom;


-(void) removeDefaltKeyboard;
-(void) animateTextView:(BOOL) up ;
-(void) layoutSwitch;

-(IBAction) btnErase:(id)sender;
-(IBAction) btnEmail:(id)sender;
-(IBAction) btnSMS:(id)sender;
-(IBAction) btnSafari:(id)sender;
-(IBAction) swtDic:(id)sender;

-(void)     setSwipeSwitch:(BOOL)bOn;
-(void)     onDone;

- (CGFloat)lineHeight;

- (void) updateAdsView;
- (void) addAdsView;

@end
