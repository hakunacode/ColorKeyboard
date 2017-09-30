//
//  MainViewController.h
//  ColorText
//
//  Created by  on 12/03/23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StyleTextView.h"


#ifdef ADS_MOBCLIX
#import "MobclixAdView.h"
#endif


@interface ColorTextViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    IBOutlet UIView*        m_viewSms;
    IBOutlet UIImageView*   m_imgTexture;
    IBOutlet UIWebView*     m_webView;
    IBOutlet UITextView*    m_textView;
    
    IBOutlet UIImageView*   m_imgTabBg;
    
    IBOutlet UITableView*   m_tableView;
    
    //button
    IBOutlet UIButton*      m_btnEdit;
    IBOutlet UIButton*      m_btnTextColor;
    IBOutlet UIButton*      m_btnTextGlow;
    IBOutlet UIButton*      m_btnTextShadow;
    IBOutlet UIButton*      m_btnBgColor;
    IBOutlet UIButton*      m_btnBgTexture;
    IBOutlet UIButton*      m_btnFontBold;
    IBOutlet UIButton*      m_btnFontItalic;
    IBOutlet UIButton*      m_btnFontUnderline;

    IBOutlet UIButton*      m_btnSend; // SKY:121103

    int     m_nTableType;
    int     m_nSelectTab;
    int     m_nTextColorIndex;
    int     m_nTextGlowIndex;
    int     m_nTextShadowIndex;
    int     m_nBgType;
    int     m_nBgColorIndex;
    int     m_nBgTextureIndex;
    int     m_nFontIndex;
    BOOL    m_bBold;
    BOOL    m_bItalic;
    BOOL    m_bUnderline;
    
    NSString*   m_strText;
    
#ifdef ADS_MOBCLIX
	MobclixAdView*          adView;
#endif

}

#ifdef ADS_MOBCLIX
@property(nonatomic,retain) MobclixAdView* adView;
#endif

- (IBAction) onEdit:(id)sender;
- (IBAction) onSend:(id)sender;
- (IBAction) onClear:(id)sender;
- (IBAction) onTab:(id)sender;
- (IBAction) onTextBtn:(id)sender;
- (IBAction) onBgBtn:(id)sender;
- (IBAction) onFontBtn:(id)sender;
- (IBAction) onCellBtn:(id)sender;
//- (IBAction) onSend:(id)sender;
- (IBAction)moreApps:(id)sender;

- (UIButton*) createColorButton:(UIColor*)color;
- (UIButton*) createTextureButton:(int)index;
- (UIButton*) createClearButton;

- (void) setText:(NSString*)str;
- (NSString*) convertHtmlString:(NSString*)str;
- (void) updateWebView;
//mms
- (void) changeBgColor:(int)index;
- (void) changeBgTexture:(int)index;

- (void) changeEditBtnImage:(BOOL)edited;
- (void) changeTabBg:(int)index;
- (void) updateBtnState:(int)index;
//font proc
- (BOOL) isExistBoldFont;
- (BOOL) isExistItalicFont;
- (BOOL) isExistBoldItalicFont;
- (NSString*) getFontName;
- (NSString*) getFontNameWithFamilyName:(NSString*)familyName;
- (NSString*) getBoldFontNameWithFamilyName:(NSString*)familyName;
- (NSString*) getItalicFontNameWithFamilyName:(NSString*)familyName;
- (NSString*) getBoldItalicFontNameWithFamilyName:(NSString*)familyName;
- (void) updateFontStyleBtn;
- (void) changeBoldBtnImage:(BOOL)bSelect;
- (void) changeItalicBtnImage:(BOOL)bSelect;
- (void) changeUnderlineBtnImage:(BOOL)bSelect;
- (void) setFontAtTextView;

- (CGSize) getStringSize:(NSString*)str;
- (UIImage*) getImage;

@end
